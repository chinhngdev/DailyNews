//
//  NewsSourcesResponseDTO.swift
//  DailyNews
//
//  Created by Chinh on 8/22/25.
//

import Foundation

struct NewsSourcesResponseDTO: Decodable {
    let status: String
    let sources: [NewsSourceDTO]
}

struct NewsSourceDTO: Decodable {
    let id: String
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String

    func toDomain() -> NewsSource {
        return NewsSource(
            id: id,
            name: name
        )
    }
}
