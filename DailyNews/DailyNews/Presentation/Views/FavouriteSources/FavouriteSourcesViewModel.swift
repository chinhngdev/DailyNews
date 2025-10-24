//
//  FavouriteSourcesViewModel.swift
//  DailyNews
//
//  Created by Chinh on 8/21/25.
//

import Foundation

@MainActor
protocol FavouriteSourcesViewModelOutput {
    var onSourcesUpdated: (([NewsSource]) -> Void)? { get set }
}

@MainActor
protocol FavouriteSourcesViewModelInput {
    func fetchNewsSources()
}

typealias FavouriteSourcesViewModel = FavouriteSourcesViewModelInput & FavouriteSourcesViewModelOutput

@MainActor
final class DefaultFavouriteSourcesViewModel {

    // MARK: - Dependencies
    private let newsUseCase: NewsUseCaseProtocol

    // MARK: - Properties
    private var newsSources: [NewsSource] = []
    private var fetchNewsSourcesTask: Task<Void, Never>?

    // MARK: - Initialization
    init(newsUseCase: NewsUseCaseProtocol) {
        self.newsUseCase = newsUseCase
    }
    
    // MARK: - Outputs
    var onSourcesUpdated: (([NewsSource]) -> Void)?
}

// MARK: - Inputs
extension DefaultFavouriteSourcesViewModel: FavouriteSourcesViewModel {
    func fetchNewsSources() {
        fetchNewsSourcesTask = Task {
            await performFetchingSources(NewsSourceRequestParams())
        }
    }
    
    private func performFetchingSources(_ request: NewsSourceRequestParams) async {
        do {
            try Task.checkCancellation()
            newsSources = try await newsUseCase.getNewsSources(with: request)
            try Task.checkCancellation()
            onSourcesUpdated?(newsSources)
        } catch is CancellationError {
        } catch {
        }
    }
}
