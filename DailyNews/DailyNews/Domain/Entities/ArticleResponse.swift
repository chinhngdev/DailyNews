//
//  ArticleResponse.swift
//  DailyNews
//
//  Created by Chinh on 7/28/25.
//

import Foundation

struct ArticleResponse {
    let status: String
    let totalResults: Int
    let articles: [Article]
}