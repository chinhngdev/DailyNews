//
//  ArticleDetailViewModel.swift
//  DailyNews
//
//  Created by Chinh on 7/28/25.
//

import Foundation

final class ArticleDetailViewModel {
    
    // MARK: - Properties
    private let article: Article

    // MARK: - Computed Properties
    var articleTitle: String {
        return article.title
    }
    
    var articleURL: String? {
        return article.url
    }

    // MARK: - Initialization
    init(article: Article) {
        self.article = article
    }
}
