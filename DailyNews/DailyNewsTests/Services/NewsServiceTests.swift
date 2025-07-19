//
//  NewsServiceTests.swift
//  DailyNewsTests
//
//  Created by Chinh on 7/3/25.
//

import XCTest
@testable import DailyNews

final class NewsServiceTests: XCTestCase {
    
    private var newsService: NewsService!
    private var mockURLSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        // Configure URLSession to use our mock protocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockURLSession = URLSession(configuration: config)
        
        // Create service
        newsService = NewsService(urlSession: mockURLSession)
        
        // Reset mock state
        MockURLProtocol.reset()
    }
    
    override func tearDown() {
        MockURLProtocol.reset()
        newsService = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    // MARK: - Success Cases
    
    func test_getNews_withValidResponse_shouldReturnArticles() async throws {
        // Arrange
        let mockData = TestHelpers.createMockArticleResponseData(articleCount: 2)
        let mockResponse = TestHelpers.createMockHTTPResponse(statusCode: 200)
        
        MockURLProtocol.mockResponseData = mockData
        MockURLProtocol.mockResponse = mockResponse
        
        // Act
        let result = try await newsService.getNews()
        
        // Assert
        XCTAssertEqual(result.status, "ok")
        XCTAssertGreaterThanOrEqual(result.totalResults, 1)
        XCTAssertGreaterThanOrEqual(result.articles.count, 1)
    }
    
    // MARK: - Error Cases
    
    func test_getNews_withUnauthorizedResponse_shouldThrowUnauthorizedError() async {
        // Arrange
        let mockResponse = TestHelpers.createMockHTTPResponse(statusCode: 401)
        MockURLProtocol.mockResponse = mockResponse
        MockURLProtocol.mockResponseData = Data() // Empty data
        
        // Act & Assert
        do {
            _ = try await newsService.getNews()
            XCTFail("Expected NewsError.unauthorized but no error was thrown")
        } catch let error as NewsError {
            XCTAssertEqual(error, NewsError.unauthorized)
        } catch {
            XCTFail("Expected NewsError.unauthorized but got \(error)")
        }
    }
    
    func test_getNews_withTooManyRequests_shouldThrowTooManyRequestsError() async {
        // Arrange
        let mockResponse = TestHelpers.createMockHTTPResponse(statusCode: 429)
        MockURLProtocol.mockResponse = mockResponse
        
        // Act & Assert
        do {
            _ = try await newsService.getNews()
            XCTFail("Expected NewsError.tooManyRequests")
        } catch let error as NewsError {
            XCTAssertEqual(error, NewsError.tooManyRequests)
        } catch {
            XCTFail("Expected NewsError.tooManyRequests but got \(error)")
        }
    }
    
    func test_getNews_withServerError_shouldThrowServerError() async {
        // Arrange
        let mockResponse = TestHelpers.createMockHTTPResponse(statusCode: 500)
        MockURLProtocol.mockResponse = mockResponse
        
        // Act & Assert
        do {
            _ = try await newsService.getNews()
            XCTFail("Expected NewsError.serverError")
        } catch let error as NewsError {
            XCTAssertEqual(error, NewsError.serverError)
        }  catch {
            XCTFail("Expected NewsError.serverError but got \(error)")
        }
    }
    
    func test_getNews_withNetworkError_shouldThrowNetworkError() async {
        // Arrange
        MockURLProtocol.mockError = TestHelpers.createNetworkError()
        
        // Act & Assert
        do {
            _ = try await newsService.getNews()
            XCTFail("Expected network error")
        } catch {
            // Network errors are passed through as-is
            XCTAssertTrue(error is NSError)
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, NSURLErrorDomain)
        }
    }
    
    func test_getNews_withInvalidJSON_shouldThrowDecodingError() async {
        // Arrange
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        let mockResponse = TestHelpers.createMockHTTPResponse(statusCode: 200)
        
        MockURLProtocol.mockResponseData = invalidJSON
        MockURLProtocol.mockResponse = mockResponse
        
        // Act & Assert
        do {
            _ = try await newsService.getNews()
            XCTFail("Expected decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
}
