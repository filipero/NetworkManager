//
//  EndpointType.swift
//
//  Created by Filipe Rodrigues Oliveira on 19/02/22.
//

import Foundation

public enum NetworkEnvironment {
    case production
}

public protocol EndpointType {
    var environment: NetworkEnvironment { get }
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var environmentBaseURL: String {
        switch environment {
        case .production: return "https://rickandmortyapi.com/api"
        }
    }
    
    public var environment: NetworkEnvironment {
        .production
    }
}
