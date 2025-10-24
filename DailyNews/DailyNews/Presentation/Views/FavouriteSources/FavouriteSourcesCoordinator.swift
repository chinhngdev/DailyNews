//
//  FavouriteSourcesCoordinator.swift
//  DailyNews
//
//  Created by Chinh on 8/21/25.
//

import UIKit

final class FavouriteSourcesCoordinator: Coordinator {
    var children: [Coordinator] = []
    let router: Router

    init(router: Router) {
        self.router = router
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let newsRepository = NewsRepository()
        let newsUseCase = NewsUseCase(newsRepository: newsRepository)
        let viewModel = DefaultFavouriteSourcesViewModel(
            newsUseCase: newsUseCase
        )
        let viewController = FavouriteSourcesViewController.instantiate(
            with: viewModel,
            delegate: self
        )
        router.present(
            viewController,
            animated: animated,
            onDismissed: onDismissed
        )
    }
}

extension FavouriteSourcesCoordinator: FavouriteSourcesViewControllerDelegate {}
