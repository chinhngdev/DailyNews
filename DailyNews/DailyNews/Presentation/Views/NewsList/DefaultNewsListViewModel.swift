//
//  NewsListViewModel.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

@MainActor
protocol NewsListViewModelOutput {
    var onLoadingStateChanged: ((Bool?) -> Void)? { get set }
    var onArticlesUpdated: (([Article]) -> Void)? { get set }
    var onErrorChanged: ((String?) -> Void)? { get set }
    var onResettingPage: (() -> Void)? { get set }
}

@MainActor
protocol NewsListViewModelInput {
    func fetchNews()
    func resetPage()
    func searchNews(with query: String?)
    func loadMoreNews()
}

typealias NewsListViewModel = NewsListViewModelInput & NewsListViewModelOutput

@MainActor
final class DefaultNewsListViewModel {

    // MARK: - Dependencies
    private let newsUseCase: NewsUseCaseProtocol
    
    // MARK: - Properties
    private var articles: [Article] = []
    private var newsRequestParams: FetchNewsRequestParams = FetchNewsRequestParams(query: "technology")
    private var fetchNewsTask: Task<Void, Never>?
    
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
    
    // MARK: - Initialization
    
    init(newsUseCase: NewsUseCaseProtocol) {
        self.newsUseCase = newsUseCase
    }
    
    deinit {
        fetchNewsTask?.cancel()
        fetchNewsTask = nil
    }

    // MARK: - Outputs

    var onLoadingStateChanged: ((Bool?) -> Void)?
    var onArticlesUpdated: (([Article]) -> Void)?
    var onErrorChanged: ((String?) -> Void)?
    var onResettingPage: (() -> Void)?
}

// MARK: - Inputs

extension DefaultNewsListViewModel: NewsListViewModel {
    func fetchNews() {
        // Cancel `fetchNewsTask` if it's running
        fetchNewsTask?.cancel()

        // Create a new task
        fetchNewsTask = Task {
            await performSearch(with: newsRequestParams)
        }
    }
    
    func resetPage() {
        newsRequestParams.resetPage()
        onResettingPage?()
    }
    
    private func handleError(error: Error) {
        if let newsError = error as? NewsError {
            errorMessage = newsError.errorDescription
        } else {
            errorMessage = L10n.commonUnknownError
        }
    }

    func searchNews(with query: String?) {
        let trimmedQuery = query?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmedQuery = trimmedQuery, !trimmedQuery.isEmpty else {
            fetchNews()
            return
        }
        
        resetPage()
        let requestValue = FetchNewsRequestParams(query: trimmedQuery)

        // Cancel `fetchNewsTask` if it's running
        fetchNewsTask?.cancel()

        // Create a new task
        fetchNewsTask = Task {
            isLoading = true
            errorMessage = nil
            await performSearch(with: requestValue)
        }
    }
    
    func loadMoreNews() {
        newsRequestParams.page += 1
        fetchNewsTask?.cancel()
        fetchNewsTask = Task {
            await performSearch(with: newsRequestParams)
        }
    }
    
    private func performSearch(with requestValue: FetchNewsRequestParams) async {
        defer {
            isLoading = false
        }
        do {
            try Task.checkCancellation()
            let response = try await newsUseCase.getNews(with: requestValue)
            try Task.checkCancellation()
            articles = response.articles
            onArticlesUpdated?(articles)
        } catch is CancellationError {
            errorMessage = nil
            return
        } catch {
            handleError(error: error)
        }
    }
}
