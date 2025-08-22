//
//  GetNewsUseCaseProtocol.swift
//  DailyNews
//
//  Created by Chinh on 7/30/25.
//

import Foundation

protocol GetNewsUseCaseProtocol {
    func getNews(with requestValue: FetchNewsRequest) async throws -> [Article]
}

final class GetNewsUseCase: GetNewsUseCaseProtocol {
    
    private let newsRepository: NewsRepositoryProtocol

    /// The repository to check the internet connection
    // private let connectionStatusRepository: ConnectionStatusRepositoryProtocol

    init(newsRepository: NewsRepositoryProtocol) {
        self.newsRepository = newsRepository
    }

    func getNews(with requestValue: FetchNewsRequest) async throws -> [Article] {
        
        // TODO: Check for internet connection before making the request
        
        let articleResponseDTO = try await newsRepository.getNews(with: requestValue)
        return articleResponseDTO.articles.map { $0.toDomain() }
    }
}
