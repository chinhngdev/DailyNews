//
//  NewListViewModel.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

final class NewListViewModel {
    
    // MARK: - Properties
    private var articles: [Article] = []
    private let newsDataService: NewsService = NewsService()

    private var currentTask: Task<Void, Error>?
    
    private var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    private var errorMessage: String? {
        didSet {
            onErrorChanged?(errorMessage)
        }
    }

    // MARK: - Callbacks for UI updates
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onArticlesUpdated: (([Article]) -> Void)?
    var onErrorChanged: ((String?) -> Void)?
    
    func fetchNews() {
        // Cancel `currentTask` if it's running
        currentTask?.cancel()

        // Create a new task
        currentTask = Task {
            await performFetch()
        }
    }
    
    private func performFetch() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await newsDataService.getNews()
            self.articles = response.articles
            onArticlesUpdated?(articles)
        } catch let newsError as NewsError {
            errorMessage = newsError.errorDescription
        } catch {
            errorMessage = "Unknown error occurred."
        }
        
        isLoading = false
    }
}
