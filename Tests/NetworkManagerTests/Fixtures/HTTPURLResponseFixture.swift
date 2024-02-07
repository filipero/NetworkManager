//
//  HTTPURLResponseFixture.swift
//  
//
//  Created by Filipe Rodrigues Oliveira on 20/02/22.
//

import Foundation

public extension HTTPURLResponse {
    static func fixture(url: URL = URL(string: "https://www.google.com/")!, statusCode: Int = 0, httpVersion: String? = nil, headerFields: [String : String]? = nil) -> HTTPURLResponse? {
        .init(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headerFields)
    }
}
