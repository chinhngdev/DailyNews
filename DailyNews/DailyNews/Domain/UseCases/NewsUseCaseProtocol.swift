//
//  NewsUseCaseProtocol.swift
//  DailyNews
//
//  Created by Chinh on 7/30/25.
//

import Foundation

protocol NewsUseCaseProtocol {
    func getNews(with requestValue: FetchNewsRequestParams) async throws -> [Article]
    func getNewsSources(with request: NewsSourceRequest) async throws -> [NewsSource]
}

final class NewsUseCase {
    
    private let newsRepository: NewsRepositoryProtocol

    /// The repository to check the internet connection
    // private let connectionStatusRepository: ConnectionStatusRepositoryProtocol

    init(newsRepository: NewsRepositoryProtocol) {
        self.newsRepository = newsRepository
    }
}

extension NewsUseCase: NewsUseCaseProtocol {
    func getNews(with requestValue: FetchNewsRequestParams) async throws -> [Article] {
        
        // TODO: Check for internet connection before making the request
        
        let articleResponseDTO = try await newsRepository.getNews(with: requestValue)
        return articleResponseDTO.articles.map { $0.toDomain() }
    }

    func getNewsSources(with request: NewsSourceRequest) async throws -> [NewsSource] {
        let newsSourcesResponseDTO = try await newsRepository.getNewsSources(with: request)
        return newsSourcesResponseDTO.sources?.compactMap { $0.toDomain() } ?? []
    }
}
