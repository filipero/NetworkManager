//
//  DummyRequest.swift
//  
//
//  Created by Filipe Rodrigues Oliveira on 20/02/22.
//

import Foundation
import NetworkManager

public class DummyRequest: EndpointType {
    public var baseURL: URL
    public var environment: NetworkEnvironment
    public var path: String
    public var httpMethod: HTTPMethod
    public var task: HTTPTask
    public var headers: HTTPHeaders?
    
    public init(baseURL: URL = URL(string:"https://www.google.com/")!, environment: NetworkEnvironment = .production, path: String = "", httpMethod: HTTPMethod = .get, task: HTTPTask = .request, headers: HTTPHeaders? = .none) {
        self.baseURL = baseURL
        self.environment = environment
        self.path = path
        self.httpMethod = httpMethod
        self.task = task
        self.headers = headers
    }
}
