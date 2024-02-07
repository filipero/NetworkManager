import Foundation

public protocol NetworkManagerProtocol {
    func request<T: Codable>(with endpointType: EndpointType, completion: @escaping (Swift.Result<T?, Error>) -> ())
}

public struct NetworkManager {
    private let router: NetworkRouterProtocol
    
    public init(router: NetworkRouterProtocol) {
        self.router = router
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<NetworkResponseError> {
        switch response.statusCode {
        case 100...199: return .failure(.informationalResponse)
        case 200...299: return .success
        case 300...399: return .failure(.redirectionMessages)
        case 400...499: return .failure(.clientError)
        case 500...599: return .failure(.serverError)
        default: return .failure(NetworkResponseError.outdated)
        }
    }
}

enum NetworkResponseError: Error {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case checkNetworkConnection
    case informationalResponse
    case redirectionMessages
    case clientError
    case serverError
    
    var localizedDescription: String {
        switch self {
        case .authenticationError:
            return "You need to be authenticated first."
        case .badRequest:
            return "Bad request."
        case .outdated:
            return "The url you requested is outdated."
        case .failed:
            return "Network request failed."
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        case .checkNetworkConnection:
            return "Please check your network connection."
        case .informationalResponse:
            return "The server is processing."
        case .redirectionMessages:
            return "The server URL is likely to have changed."
        case .clientError:
            return "The request is problematic."
        case .serverError:
            return "The server was unable to process the request."
        }
    }
}

extension NetworkManager: NetworkManagerProtocol {
    public func request<T: Codable>(with endpointType: EndpointType, completion: @escaping (Swift.Result<T?, Error>) -> ()) {
        router.request(endpointType) { data, response, error in
            if error != nil {
                completion(.failure(NetworkResponseError.checkNetworkConnection))
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkResponseError.noData))
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                        completion(.success(apiResponse))
                    } catch(let error) {
                        print(error)
                        completion(.failure(NetworkResponseError.unableToDecode))
                    }
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            }
        }
    }
}

enum Result<String> {
    case success
    case failure(String)
}
