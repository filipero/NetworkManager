//
//  NetworkRouter.swift
//
//  Created by Filipe Rodrigues Oliveira on 19/02/22.
//

import Foundation

public protocol NetworkRouterProtocol: AnyObject {
    func request(_ route: EndpointType, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ())
}
