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
        let viewController = UINavigationController(rootViewController: NewsListViewController.instantiate(delegate: self))
        router.present(
            viewController,
            animated: animated,
            onDismissed: onDismissed
        )
    }
}

extension NewsListCoordinator: NewsListViewControllerDelegate {
    func didSelectArticle(_ article: Article) {
        let coordinator = ArticleDetailCoordinator(router: router, article: article)
        children.append(coordinator)
        coordinator.present(animated: true) { [weak self] in
            self?.children.removeLast()
        }
    }

    func didTapSearchButton() {
    }
}
