//
//  FetchNewsRequest.swift
//  DailyNews
//
//  Created by Chinh on 8/2/25.
//

import Foundation

struct FetchNewsRequest {
    let query: String
    let sortBy: NewsSortBy
    let pageSize: Int
    let page: Int

    init(
        query: String = "",
        sortBy: NewsSortBy = .relevancy,
        pageSize: Int = 10,
        page: Int = 1
    ) {
        self.query = query
        self.sortBy = sortBy
        self.pageSize = pageSize
        self.page = page
    }
}

enum NewsSortBy: String {
    case relevancy = "relevancy"
}
