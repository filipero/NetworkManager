import XCTest
@testable import NetworkManager

final class NetworkManagerTests: XCTestCase {
    private let networkRouterSpy = NetworkRouterSpy()
    private lazy var sut: NetworkManager = NetworkManager(router: networkRouterSpy)
    
    func test_request_shouldBeCalled() {
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in  }
        XCTAssertTrue(networkRouterSpy.requestCalled)
    }
    
    func test_request_callCountShouldBe1() {
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in  }
        XCTAssertEqual(networkRouterSpy.requestCallCount, 1)
    }
    
    func test_request_whenErrorIsNotNil_ShouldReturnNetworkConnectionError() throws {
        var expectedResult: Swift.Result<RequestDummyResponse?, Error>?
        networkRouterSpy.requestToReturn = (nil, nil, DummyError.dummy)
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in
            expectedResult = response
        }
        guard case .failure(let error) = expectedResult else {
            XCTFail("Result should be .failure")
            return
        }
        let networkError = try XCTUnwrap(error as? NetworkResponseError)
        XCTAssertEqual(networkError, .checkNetworkConnection)
    }
    
    func test_request_whenResponseNotNil_WithStatusCode404_ShouldReturnauthenticationError() throws {
        var expectedResult: Swift.Result<RequestDummyResponse?, Error>?
        networkRouterSpy.requestToReturn = (nil, HTTPURLResponse.fixture(statusCode: 404), nil)
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in
            expectedResult = response
        }
        guard case .failure(let error) = expectedResult else {
            XCTFail("Result should be .failure")
            return
        }
        let networkError = try XCTUnwrap(error as? NetworkResponseError)
        XCTAssertEqual(networkError, .clientError)
    }
    
    func test_request_whenResponseNotNil_WithStatusCode600_ShouldReturnOutdatedError() throws {
        var expectedResult: Swift.Result<RequestDummyResponse?, Error>?
        networkRouterSpy.requestToReturn = (nil, HTTPURLResponse.fixture(statusCode: 600), nil)
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in
            expectedResult = response
        }
        guard case .failure(let error) = expectedResult else {
            XCTFail("Result should be .failure")
            return
        }
        let networkError = try XCTUnwrap(error as? NetworkResponseError)
        XCTAssertEqual(networkError, .outdated)
    }
    
    func test_request_whenResponseNotNil_WithStatusCode1999_ShouldReturnFailedError() throws {
        var expectedResult: Swift.Result<RequestDummyResponse?, Error>?
        networkRouterSpy.requestToReturn = (nil, HTTPURLResponse.fixture(statusCode: 1999), nil)
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in
            expectedResult = response
        }
        guard case .failure(let error) = expectedResult else {
            XCTFail("Result should be .failure")
            return
        }
        let networkError = try XCTUnwrap(error as? NetworkResponseError)
        XCTAssertEqual(networkError, .outdated)
    }
    
    func test_request_whenResponseNotNil_WithStatusCode500_ShouldReturnBadRequestError() throws {
        var expectedResult: Swift.Result<RequestDummyResponse?, Error>?
        networkRouterSpy.requestToReturn = (nil, HTTPURLResponse.fixture(statusCode: 500), nil)
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in
            expectedResult = response
        }
        guard case .failure(let error) = expectedResult else {
            XCTFail("Result should be .failure")
            return
        }
        let networkError = try XCTUnwrap(error as? NetworkResponseError)
        XCTAssertEqual(networkError, .serverError)
    }
    
    func test_request_whenResponseNotNilAndDataNotNil_withStatusCodeSuccess_ShouldReturnSuccess() throws {
        var expectedResult: Swift.Result<RequestDummyResponse?, Error>?
        networkRouterSpy.requestToReturn = (.validData(), HTTPURLResponse.fixture(statusCode: 200), nil)
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in
            expectedResult = response
        }
        guard case .success(let response) = expectedResult else {
            XCTFail("Result should be .success")
            return
        }
        XCTAssertEqual(response?.value, true)
    }
    
    func test_request_whenResponseNotNilAndDataNotNil_withStatusCodeSuccessAndInvalidData_ShouldFailToDecode() throws {
        var expectedResult: Swift.Result<RequestDummyResponse?, Error>?
        networkRouterSpy.requestToReturn = (.invalidData(), HTTPURLResponse.fixture(statusCode: 200), nil)
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in
            expectedResult = response
        }
        guard case .failure(let error) = expectedResult else {
            XCTFail("Result should be .failure")
            return
        }
        let networkError = try XCTUnwrap(error as? NetworkResponseError)
        XCTAssertEqual(networkError, .unableToDecode)
    }
    
    func test_request_whenResponseNotNilAndDataNil_withStatusCodeSuccess_ShouldReturnNoDataError() throws {
        var expectedResult: Swift.Result<RequestDummyResponse?, Error>?
        networkRouterSpy.requestToReturn = (nil, HTTPURLResponse.fixture(statusCode: 200), nil)
        sut.request(with: DummyRequest()) { (response: Swift.Result<RequestDummyResponse?, Error>) in
            expectedResult = response
        }
        guard case .failure(let error) = expectedResult else {
            XCTFail("Result should be .failure")
            return
        }
        let networkError = try XCTUnwrap(error as? NetworkResponseError)
        XCTAssertEqual(networkError, .noData)
    }
}

private extension Data {
    static func validData() -> Self {
        """
        {"value": true}
        """.data(using: .utf8) ?? .init()
    }
    
    static func invalidData() -> Self {
        """
        "value": aaa}
        """.data(using: .utf8) ?? .init()
    }
}
