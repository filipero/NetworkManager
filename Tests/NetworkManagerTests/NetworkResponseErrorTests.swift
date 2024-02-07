//
//  NetworkResponseErrorTests.swift
//  
//
//  Created by Filipe Rodrigues Oliveira on 20/02/22.
//

import XCTest
@testable import NetworkManager

final class NetworkResponseErrorTests: XCTestCase {
    private var sut: NetworkResponseError?
    
    func test_authenticationError() {
        sut = NetworkResponseError.authenticationError
        XCTAssertEqual(sut?.localizedDescription, "You need to be authenticated first.")
    }
    func test_badRequest() {
        sut = NetworkResponseError.badRequest
        XCTAssertEqual(sut?.localizedDescription, "Bad request.")
    }
    func test_outdated() {
        sut = NetworkResponseError.outdated
        XCTAssertEqual(sut?.localizedDescription, "The url you requested is outdated.")
    }
    func test_failed() {
        sut = NetworkResponseError.failed
        XCTAssertEqual(sut?.localizedDescription, "Network request failed.")
    }
    func test_noData() {
        sut = NetworkResponseError.noData
        XCTAssertEqual(sut?.localizedDescription, "Response returned with no data to decode.")
    }
    func test_unableToDecode() {
        sut = NetworkResponseError.unableToDecode
        XCTAssertEqual(sut?.localizedDescription, "We could not decode the response.")
    }
    func test_checkNetworkConnection() {
        sut = NetworkResponseError.checkNetworkConnection
        XCTAssertEqual(sut?.localizedDescription, "Please check your network connection.")
    }
}


