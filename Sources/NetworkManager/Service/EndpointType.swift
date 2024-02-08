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
