//
//  NewsRepositoryProtocol.swift
//  DailyNews
//
//  Created by Chinh on 8/22/25.
//

import Foundation

protocol NewsRepositoryProtocol {
    func getNews(with requestValue: FetchNewsRequestParams) async throws -> ArticleResponseDTO
    func getNewsSources(with request: NewsSourceRequest) async throws -> NewsSourcesResponseDTO
}
