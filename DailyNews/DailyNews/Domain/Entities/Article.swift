//
//  Article.swift
//  DailyNews
//
//  Created by Chinh on 7/28/25.
//

import Foundation

struct Article {
    let source: NewsSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
