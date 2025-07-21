//
//  NewsListViewModel.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

final class NewsListViewModel {
    
    // MARK: - Properties
    private var articles: [Article] = []
    private var newsDataService: NewsServiceProtocol

    private var fetchNewsTask: Task<Void, Error>?
    
    private var isLoading: Bool = false {
        didSet {
            // TODO: Resolve the warning: UIActivityIndicatorView.startAnimating() must be used from main thread only
//            onLoadingStateChanged?(isLoading)
        }
    }
    
    private var errorMessage: String? {
        didSet {
            onErrorChanged?(errorMessage)
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
            self.articles = response.articles
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
