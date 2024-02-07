//
//  DummyDataTask.swift
//  
//
//  Created by Filipe Rodrigues Oliveira on 20/02/22.
//

import Foundation

class DataTaskSpy: URLSessionDataTask {
    private(set) var dataTaskResumed: Bool = false
    override func resume() {
        dataTaskResumed = true
    }
}
