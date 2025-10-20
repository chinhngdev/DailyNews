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
    @MainActor
    private var articles: [Article] = []

    private var fetchNewsTask: Task<Void, Never>?
    
    @MainActor
    private var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    @MainActor
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
        cancelFetchNewsTask()
    }

    // MARK: - Outputs
    
    @MainActor var onLoadingStateChanged: ((Bool?) -> Void)?
    @MainActor var onArticlesUpdated: (([Article]) -> Void)?
    @MainActor var onErrorChanged: ((String?) -> Void)?

    private func cancelFetchNewsTask() {
        fetchNewsTask?.cancel()
        fetchNewsTask = nil
    }
}

// MARK: - Inputs

extension DefaultNewsListViewModel: NewsListViewModel {
    func fetchNews() {
        // Cancel `currentTask` if it's running
        cancelFetchNewsTask()

        // Create a new task
        fetchNewsTask = Task {
            await performSearch(with: FetchNewsRequest(query: "technology") )
        }
    }
    
    @MainActor
    private func handleError(error: Error) {
        if let newsError = error as? NewsError {
            errorMessage = newsError.errorDescription
        } else {
            errorMessage = L10n.commonUnknownError
        }
    }

    func searchNews(with query: String?) {
        guard let query = query, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            fetchNews()
            return
        }

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let requestValue = FetchNewsRequest(query: trimmedQuery)

        // Cancel `currentTask` if it's running
        cancelFetchNewsTask()

        // Create a new task
        fetchNewsTask = Task {
            await MainActor.run {
                isLoading = true
                errorMessage = nil
            }
            await performSearch(with: requestValue)
        }
    }
    
    private func performSearch(with requestValue: FetchNewsRequest) async {
        do {
            try Task.checkCancellation()
            let response = try await newsUseCase.getNews(with: requestValue)
            try Task.checkCancellation()
            await MainActor.run {
                articles = response
                isLoading = false
                onArticlesUpdated?(articles)
            }
        } catch is CancellationError {
            await MainActor.run {
                isLoading = false
                errorMessage = nil
            }
            return
        } catch {
            await MainActor.run  {
                isLoading = false
                handleError(error: error)
            }
        }
    }
}
