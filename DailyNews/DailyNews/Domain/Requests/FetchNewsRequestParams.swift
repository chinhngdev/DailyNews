//
//  FetchNewsRequestParams.swift
//  DailyNews
//
//  Created by Chinh on 8/2/25.
//

import Foundation

struct FetchNewsRequestParams {
    var query: String
    let sortBy: NewsSortBy
    let pageSize: Int
    var page: Int

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
    
    mutating func resetPage() {
        self.page = 1
    }
}

enum NewsSortBy: String {
    case relevancy = "relevancy"
}
