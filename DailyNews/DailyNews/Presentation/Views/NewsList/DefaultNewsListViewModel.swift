//
//  NewsListViewModel.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

import Dispatch

protocol NewsListViewModelOutput {
    var onLoadingStateChanged: ((Bool?) -> Void)? { get set }
    var onArticlesUpdated: (([Article]) -> Void)? { get set }
    var onErrorChanged: ((String?) -> Void)? { get set }
}

protocol NewsListViewModelInput {
    func fetchNews()
    func searchNews(with query: String?)
}

typealias NewsListViewModel = NewsListViewModelInput & NewsListViewModelOutput

final class DefaultNewsListViewModel {

    // MARK: - Dependencies
    private let newsUseCase: NewsUseCaseProtocol
    
    // MARK: - Properties
    private var articles: [Article] = []
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
}

// MARK: - Inputs

extension DefaultNewsListViewModel: NewsListViewModel {
    func fetchNews() {
        // Cancel `fetchNewsTask` if it's running
        fetchNewsTask?.cancel()

        // Create a new task
        fetchNewsTask = Task {
            await performSearch(with: FetchNewsRequest(query: "technology") )
        }
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

        let requestValue = FetchNewsRequest(query: trimmedQuery)

        // Cancel `fetchNewsTask` if it's running
        fetchNewsTask?.cancel()

        // Create a new task
        fetchNewsTask = Task {
            isLoading = true
            errorMessage = nil
            await performSearch(with: requestValue)
        }
    }
    
    private func performSearch(with requestValue: FetchNewsRequest) async {
        defer {
            isLoading = false
        }
        do {
            try Task.checkCancellation()
            let response = try await newsUseCase.getNews(with: requestValue)
            try Task.checkCancellation()
            articles = response
            onArticlesUpdated?(articles)
        } catch is CancellationError {
            errorMessage = nil
            return
        } catch {
            handleError(error: error)
        }
    }
}
