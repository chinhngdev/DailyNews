//
//  GetNewsUseCase.swift
//  DailyNews
//
//  Created by Chinh on 7/30/25.
//

import Foundation

protocol GetNewsUseCase {
    func execute() async throws -> [Article]
}

final class DefaultGetNewsUseCase: GetNewsUseCase {
    
    private let newsService: NewsRepository

    /// The repository to query the news from the database
    // private let newsQueriesRepository: NewsQueriesRepository

    init(newsService: NewsRepository) {
        self.newsService = newsService
    }

    func execute() async throws -> [Article] {
        let articleResponseDTO = try await newsService.getNews()
        return articleResponseDTO.articles.map { $0.toDomain() }
    }
}
