//
//  NewListViewModel.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

final class NewListViewModel {
    private var articles: [Article]?
    private let newsDataService: NewsDataService = NewsDataService()

    func fetchNews() async throws {
        let news = try await newsDataService.getNews()
        self.articles = news.articles
        print(articles ?? [])
    }
}
