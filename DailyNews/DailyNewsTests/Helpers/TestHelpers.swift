//
//  TestHelpers.swift
//  DailyNewsTests
//
//  Created by Chinh on 7/3/25.
//

import Foundation
@testable import DailyNews

struct TestHelpers {
    
    // Create valid ArticleResponse JSON
    static func createMockArticleResponseData(articleCount: Int = 2) -> Data {
        let mockResponse = """
        {
            "status": "ok",
            "totalResults": \(articleCount),
            "articles": [
                {
                    "source": {
                        "id": "test-source",
                        "name": "Test News"
                    },
                    "author": "Test Author",
                    "title": "Test Article Title",
                    "description": "Test article description",
                    "url": "https://test.com/article1",
                    "urlToImage": "https://test.com/image1.jpg",
                    "publishedAt": "2025-07-02T10:00:00Z",
                    "content": "Test article content..."
                },
                {
                    "source": {
                        "id": "tech-source",
                        "name": "Tech News"
                    },
                    "author": "Tech Author",
                    "title": "Another Test Article",
                    "description": "Another test description",
                    "url": "https://test.com/article2",
                    "urlToImage": "https://test.com/image2.jpg",
                    "publishedAt": "2025-07-02T11:00:00Z",
                    "content": "Another test content..."
                }
            ]
        }
        """.trimmed
        
        return mockResponse.data(using: .utf8) ?? Data()
    }
    
    // Create HTTP response with specific status code
    static func createMockHTTPResponse(statusCode: Int, url: String = "https://newsapi.org/v2/everything") -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: url)!,
            statusCode: statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!
    }
    
    // Create network error
    static func createNetworkError() -> NSError {
        return NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorNotConnectedToInternet,
            userInfo: [NSLocalizedDescriptionKey: "No internet connection"]
        )
    }
}

private extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
