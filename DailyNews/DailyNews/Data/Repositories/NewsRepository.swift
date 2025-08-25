//
//  NewsRepository.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

import Foundation

final class NewsRepository {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
}

extension NewsRepository: NewsRepositoryProtocol {
    func getNews(with requestValue: FetchNewsRequest) async throws -> ArticleResponseDTO {
        let router = NewsRouter.everything(requestValue)
        return try await networkService.request(router, responseType: ArticleResponseDTO.self)
    }
}
