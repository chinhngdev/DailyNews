//
//  ArticleResponseDTO.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import Foundation

import Foundation

struct ArticleResponseDTO: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]

    func toDomain() -> ArticleResponse {
        return ArticleResponse(
            status: status,
            totalResults: totalResults,
            articles: articles.map { $0.toDomain() }
        )
    }
}

struct ArticleDTO: Decodable {
    let source: NewsSourceDTO
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    func toDomain() -> Article {
        return Article(
            source: source.toDomain(),
            author: author,
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content
        )
    }
}
