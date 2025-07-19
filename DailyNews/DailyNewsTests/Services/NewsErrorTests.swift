//
//  NewsErrorTests.swift
//  DailyNewsTests
//
//  Created by Chinh on 7/2/25.
//

import XCTest
@testable import DailyNews

final class NewsErrorTests: XCTestCase {
    
    // Test error descriptions are user-friendly
    func testErrorDescriptions() {
        // Arrange & Act & Assert
        XCTAssertEqual(NewsError.badRequest.errorDescription, "Bad request")
        XCTAssertEqual(NewsError.unauthorized.errorDescription, "Unauthorized")
        XCTAssertEqual(NewsError.tooManyRequests.errorDescription, "Too many requests")
        XCTAssertEqual(NewsError.serverError.errorDescription, "Server error")
        XCTAssertEqual(NewsError.invalidURL.errorDescription, "Invalid URL")
        XCTAssertEqual(NewsError.invalidResponse.errorDescription, "Invalid response")
        XCTAssertEqual(NewsError.invalidData.errorDescription, "Invalid data")
    }
    
    // Test error conformance to Error protocol
    func testNewsErrorConformsToError() {
        // Arrange
        let error: Error = NewsError.unauthorized
        
        // Act & Assert
        XCTAssertTrue(error is NewsError)
        XCTAssertEqual(error as? NewsError, NewsError.unauthorized)
    }
    
    // Test error raw values (for API mapping)
    func testErrorRawValues() {
        // These should match HTTP status codes where applicable
        XCTAssertEqual(NewsError.badRequest.rawValue, 0)
        XCTAssertEqual(NewsError.unauthorized.rawValue, 1)
        // Add assertions for other cases
    }
}
