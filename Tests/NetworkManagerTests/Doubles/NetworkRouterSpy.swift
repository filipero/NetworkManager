//
//  NetworkRouterSpy.swift
//  
//
//  Created by Filipe Rodrigues Oliveira on 20/02/22.
//

import Foundation
import NetworkManager

public class NetworkRouterSpy: NetworkRouterProtocol {
    private(set) var requestCalled: Bool = false
    private(set) var requestCallCount: Int = 0
    private(set) var requestRoutePassed: EndpointType?
    var requestToReturn: (Data?, URLResponse?, Error?) = (nil, nil, nil)
    
    public func request(_ route: EndpointType, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        requestCalled = true
        requestCallCount += 1
        requestRoutePassed = route
        completion(requestToReturn.0, requestToReturn.1, requestToReturn.2)
    }
}
