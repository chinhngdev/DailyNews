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
}

typealias NewsListViewModel = NewsListViewModelInput & NewsListViewModelOutput

final class DefaultNewsListViewModel: NewsListViewModel {

    // MARK: - Dependencies
    private let newsUseCase: GetNewsUseCase
    
    // MARK: - Properties
    private var articles: [Article] = [] {
        willSet {
            fetchNewsTask?.cancel()
            fetchNewsTask = nil
        }
    }

    private var fetchNewsTask: Task<Void, Error>?
    
    private var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.onLoadingStateChanged?(self?.isLoading)
            }
        }
    }
    
    private var errorMessage: String? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.onErrorChanged?(self?.errorMessage)
            }
        }
    }
    
    // MARK: - Initialization
    init(newsUseCase: GetNewsUseCase) {
        self.newsUseCase = newsUseCase
    }
    
    deinit {
        fetchNewsTask?.cancel()
    }

    // MARK: - Outputs
    
    var onLoadingStateChanged: ((Bool?) -> Void)?
    var onArticlesUpdated: (([Article]) -> Void)?
    var onErrorChanged: ((String?) -> Void)?
    
    // MARK: - Inputs
    
    // TODO: Move to `NewsUseCase`
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
            let response = try await newsUseCase.execute()
            self.articles = response
            await MainActor.run {
                onArticlesUpdated?(articles)
            }
        } catch {
            handleError(error: error)
        }
        
        isLoading = false
    }

    private func handleError(error: Error) {
        if let newsError = error as? NewsError {
            errorMessage = newsError.errorDescription
        } else {
            errorMessage = "Unknown error occurred."
        }
    }
}
