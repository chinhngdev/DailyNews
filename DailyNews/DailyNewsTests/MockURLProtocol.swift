//
//  MockURLProtocol.swift
//  DailyNewsTests
//
//  Created by Chinh on 7/3/25.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    
    // Static properties to control mock behavior
    static var mockResponseData: Data?
    static var mockResponse: HTTPURLResponse?
    static var mockError: Error?
    
    // Reset all mocks between tests
    static func reset() {
        mockResponseData = nil
        mockResponse = nil
        mockError = nil
    }
    
    // Tell URLSession this protocol can handle the request
    override class func canInit(with request: URLRequest) -> Bool {
        return true  // Handle all requests
    }
    
    // Return the request unchanged
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // This is where the magic happens - provide mock response
    override func startLoading() {
        // If we have a mock error, return it
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        // If we have a mock response, return it
        if let response = MockURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        // If we have mock data, return it
        if let data = MockURLProtocol.mockResponseData {
            client?.urlProtocol(self, didLoad: data)
        }
        
        // Signal completion
        client?.urlProtocolDidFinishLoading(self)
    }
    
    // Required method - not used in our case
    override func stopLoading() {
        // Nothing to do here
    }
}
