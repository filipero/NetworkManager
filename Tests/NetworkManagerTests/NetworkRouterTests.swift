//
//  NetworkRouterTests.swift
//  
//
//  Created by Filipe Rodrigues Oliveira on 20/02/22.
//

import XCTest
@testable import NetworkManager

final class NetworkRouterTests: XCTestCase {
    private let urlSessionSpy: URLSessionSpy = URLSessionSpy()
    private var dataTaskSpy: DataTaskSpy = DataTaskSpy()
    private lazy var sut: NetworkRouter = NetworkRouter(session: urlSessionSpy)
    
    func test_request_ShouldBeCalled() {
        sut.request(DummyRequest()) { data, response, error in
        }
        XCTAssertTrue(urlSessionSpy.dataTaskCalled)
    }
    
    func test_request_callCountShouldBe1() {
        sut.request(DummyRequest()) { data, response, error in
        }
        XCTAssertEqual(urlSessionSpy.dataTaskCallCount, 1)
    }
    
    func test_request_dataTaskRequestPassedEqualsRequestPassed() {
        let route = DummyRequest(baseURL: URL(string:"https://www.google.com/")!,
                                 path: "1234",
                                 httpMethod: .delete)
        sut.request(route) { data, response, error in
        }
        
        XCTAssertEqual(urlSessionSpy.dataTaskRequestPassed?.url?.absoluteString, "https://www.google.com/1234")
        XCTAssertEqual(urlSessionSpy.dataTaskRequestPassed?.cachePolicy, .reloadIgnoringLocalAndRemoteCacheData)
        XCTAssertEqual(urlSessionSpy.dataTaskRequestPassed?.timeoutInterval, 10.0)
        XCTAssertEqual(urlSessionSpy.dataTaskRequestPassed?.httpMethod, "DELETE")
    }
    
    func test_DataTask_wasResumed() {
        urlSessionSpy.dataTaskToBeReturned = dataTaskSpy
        sut.request(DummyRequest()) { data, response, error in
        }
        XCTAssertTrue(dataTaskSpy.dataTaskResumed)
    }
    
    func test_request_failedToBuildRequest_withrequestParameters() throws {
        let bogusStr = String(
            bytes: [0xD8, 0x00] as [UInt8],
            encoding: String.Encoding.utf16BigEndian
        )
        var result: (data: Data?, response: URLResponse?, error: Error?)
        let request = DummyRequest(task: .requestParameters(bodyParameters: ["": bogusStr as Any],
                                                            bodyEncoding: .jsonEncoding,
                                                            urlParameters: nil))
        
        sut.request(request) { data, response, error in
            result = (data, response, error)
        }
        let networkError = try XCTUnwrap(result.error as? NetworkError)
        XCTAssertEqual(networkError, .encodingFailed)
    }
    
    func test_request_failedToBuildRequest_withrequestParametersAndHeaders() throws {
        let bogusStr = String(
            bytes: [0xD8, 0x00] as [UInt8],
            encoding: String.Encoding.utf16BigEndian
        )
        var result: (data: Data?, response: URLResponse?, error: Error?)
        let request = DummyRequest(task: .requestParametersAndHeaders(bodyParameters: ["": bogusStr as Any],
                                                                      bodyEncoding: .jsonEncoding,
                                                                      urlParameters: nil,
                                                                      additionHeaders: nil))
        
        sut.request(request) { data, response, error in
            result = (data, response, error)
        }
        let networkError = try XCTUnwrap(result.error as? NetworkError)
        XCTAssertEqual(networkError, .encodingFailed)
    }
}

class URLSessionSpy: URLSession {
    private(set) var dataTaskCalled: Bool = false
    private(set) var dataTaskCallCount: Int = 0
    private(set) var dataTaskRequestPassed: URLRequest?
    var dataTaskToBeReturned: DataTaskSpy = DataTaskSpy()
    var completionToBeReturned: (Data?, URLResponse?, Error?) = (nil, nil, nil)
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCalled = true
        dataTaskCallCount += 1
        dataTaskRequestPassed = request
        completionHandler(completionToBeReturned.0, completionToBeReturned.1, completionToBeReturned.2)
        return dataTaskToBeReturned
    }
}
