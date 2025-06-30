//
//  NewsDataService.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

import Foundation

final class NewsDataService {
    func getNews() async throws -> ArticleResponse {
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

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NewsError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            let news = try decoder.decode(ArticleResponse.self, from: data)
            return news
        } catch {
            throw NewsError.invalidData
        }
    }
}
