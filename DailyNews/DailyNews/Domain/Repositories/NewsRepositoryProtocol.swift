//
//  NewsRepositoryProtocol.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

import Foundation

protocol NewsRepositoryProtocol {
    func getNews() async throws -> ArticleResponseDTO
}

final class NewsRepository {
    
    private let urlSession: URLSession
    
    /// The repository to query the news from the database
    // private let newsQueriesRepository: NewsQueriesRepository
    
    // MARK: - Initializer
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
}

extension NewsRepository: NewsRepositoryProtocol {
    func getNews() async throws -> ArticleResponseDTO {
        var urlComponents = URLComponents(string: APIConfiguration.newsAPIBaseURL)
        urlComponents?.path = "/v2/everything"
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: "technology"),
            URLQueryItem(name: "sortBy", value: "relevancy"),
            URLQueryItem(name: "pageSize", value: "20"),
            URLQueryItem(name: "page", value: "1")
        ]

        // Khi urlCoponents?.url được gọi thì Swift sẽ tự động xây dựng URL hoàn chỉnh bao gồm cả query parameters từ queryItems
        // Ví dụ: https://newsapi.org/v2/everything?q=technology&sortBy=relevancy&pageSize=20&page=1
        guard let url = urlComponents?.url else {
            throw NewsError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(APIConfiguration.newsAPIKey, forHTTPHeaderField: "Authorization")
        
        // Set timeout for avoiding hang forever
        request.timeoutInterval = APIConfiguration.apiTimeout
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            // Check for HTTP status code
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NewsError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw NewsError.unauthorized
            case 429:
                throw NewsError.tooManyRequests
            case 500:
                throw NewsError.serverError
            default:
                throw NewsError.invalidResponse
            }
            
            // Decode JSON
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            let news = try decoder.decode(ArticleResponseDTO.self, from: data)
            return news
        } catch let error as NewsError {
            throw error
        }
    }
}
