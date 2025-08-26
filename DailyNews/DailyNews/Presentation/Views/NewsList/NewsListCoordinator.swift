//
//  NewsListCoordinator.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import UIKit

final class NewsListCoordinator: Coordinator {
    var children: [Coordinator] = []
    let router: Router

    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let newsRepository = NewsRepository()
        let newsUseCase = NewsUseCase(newsRepository: newsRepository)
        let viewModel = DefaultNewsListViewModel(
            newsUseCase: newsUseCase
        )
        let viewController = NewsListViewController.instantiate(
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

extension NewsListCoordinator: NewsListViewControllerDelegate {
    func didSelectArticle(_ viewController: NewsListViewController, _ article: Article) {
        guard let navigationController = viewController.navigationController else { return }
        let navigationRouter = NavigationRouter(navigationController: navigationController)
        
        let coordinator = ArticleDetailCoordinator(router: navigationRouter, article: article)
        presentChild(coordinator, animated: true, onDismissed: nil)
    }
}
