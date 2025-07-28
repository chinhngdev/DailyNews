//
//  NewsListViewModel.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

import Dispatch

final class NewsListViewModel {
    
    // MARK: - Properties
    private var articles: [Article] = []
    private var newsDataService: NewsServiceProtocol

    private var fetchNewsTask: Task<Void, Error>?
    
    private var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.onLoadingStateChanged?(self.isLoading)
            }
        }
    }
    
    private var errorMessage: String? {
        didSet {
            DispatchQueue.main.async {
                self.onErrorChanged?(self.errorMessage)
            }
        }
    }
    
    // MARK: - Initialization
    init(newsDataService: NewsServiceProtocol = NewsService()) {
        self.newsDataService = newsDataService
    }
    
    deinit {
        fetchNewsTask?.cancel()
    }

    // MARK: - Callbacks for UI updates
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onArticlesUpdated: (([Article]) -> Void)?
    var onErrorChanged: ((String?) -> Void)?
    
    func fetchNews() {
        // Cancel `currentTask` if it's running
        fetchNewsTask?.cancel()

        // Create a new task
        fetchNewsTask = Task {
            await performFetch()
        }
    }
    
    private func performFetch() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await newsDataService.getNews()
            self.articles = response.toDomain().articles
            await MainActor.run {
                onArticlesUpdated?(articles)
            }
        } catch let newsError as NewsError {
            errorMessage = newsError.errorDescription
        } catch {
            errorMessage = "Unknown error occurred."
        }
        
        isLoading = false
    }
}
