//
//  GetNewsSourcesUseCaseProtocol.swift
//  DailyNews
//
//  Created by Chinh on 8/22/25.
//

import Foundation

protocol GetNewsSourcesUseCaseProtocol {
    func getNewsSources(with request: NewsSourceRequest) async throws -> [NewsSource]
}

final class GetNewsSourcesUseCase {
    private let newsSourceRepository: NewsSourceRepositoryProtocol

    init(newsSourceRepository: NewsSourceRepositoryProtocol) {
        self.newsSourceRepository = newsSourceRepository
    }
}

extension GetNewsSourcesUseCase: GetNewsSourcesUseCaseProtocol {
    func getNewsSources(with request: NewsSourceRequest) async throws -> [NewsSource] {
        let newsSourcesResponseDTO = try await newsSourceRepository.getNewsSources(with: request)
        return newsSourcesResponseDTO.sources.map { $0.toDomain() }
    }
}
