//
//  EndpointTypeTests.swift
//  
//
//  Created by Filipe Rodrigues Oliveira on 20/02/22.
//

import XCTest
@testable import NetworkManager

final class EndpointTypeTests: XCTestCase {
    private var sut: EndpointType = DummyRequest(baseURL: URL(string:"https://rickandmortyapi.com/api")!)
    private var expectedEnvironment: NetworkEnvironment = .production
    private var expectedEnvironmentBaseURL = "https://rickandmortyapi.com/api"
    private lazy var expectedBaseURL: URL? = URL(string: expectedEnvironmentBaseURL)
    
    func test_environment_isExpectedEnvironment() {
        XCTAssertEqual(sut.environment, expectedEnvironment)
    }
    
    func test_environmentBaseURL_isExpectedEnvironmentBaseURL() {
        XCTAssertEqual(sut.environmentBaseURL, expectedEnvironmentBaseURL)
    }
    
    func test_baseURL_isExpectedBaseURL() {
        XCTAssertEqual(sut.baseURL, expectedBaseURL)
    }
}
