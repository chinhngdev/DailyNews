//
//  NewsSourceRequestParams.swift
//  DailyNews
//
//  Created by Chinh on 8/22/25.
//

import Foundation

struct NewsSourceRequestParams {
    var category: String?
    var language: String?
    var country: String?

    init(
        category: String? = "general",
        language: String? = "en",
        country: String? = "us"
    ) {
        self.category = category
        self.language = language
        self.country = country
    }
}
