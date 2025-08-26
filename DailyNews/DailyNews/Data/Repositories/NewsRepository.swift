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
        let response = try await networkService.request(router, responseType: ArticleResponseDTO.self)
        
        // Handle different status codes and map to domain-specific errors
        switch response.statusCode {
        case 200...299:
            guard let articleResponse = response.data else {
                throw NewsError.invalidData
            }
            return articleResponse
            
        case 400:
            throw NewsError.badRequest
            
        case 401:
            throw NewsError.unauthorized
            
        case 429:
            throw NewsError.tooManyRequests
            
        case 500...599:
            throw NewsError.serverError
            
        default:
            throw NewsError.invalidResponse
        }
    }

    func getNewsSources(with request: NewsSourceRequest) async throws -> NewsSourcesResponseDTO {
        let router = NewsRouter.newsSources(request)
        let response = try await networkService.request(router, responseType: NewsSourcesResponseDTO.self)

        // Handle different status codes and map to domain-specific errors
        switch response.statusCode {
        case 200...299:
            guard let newsSourcesResponse = response.data else {
                throw NewsError.invalidData
            }
            return newsSourcesResponse
        case 400:
            throw NewsError.badRequest
            
        case 401:
            throw NewsError.unauthorized
            
        case 429:
            throw NewsError.tooManyRequests
            
        case 500...599:
            throw NewsError.serverError
            
        default:
            throw NewsError.invalidResponse
        }
    }
}
