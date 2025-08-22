//
//  NewsSourceRepositoryProtocol.swift
//  DailyNews
//
//  Created by Chinh on 8/22/25.
//

import Foundation

protocol NewsSourceRepositoryProtocol {
    func getNewsSources(with request: NewsSourceRequest) async throws -> NewsSourcesResponseDTO
}
