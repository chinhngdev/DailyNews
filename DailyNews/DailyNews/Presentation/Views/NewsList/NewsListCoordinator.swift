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
        let viewController = NewsListViewController.instantiate(delegate: self)
        router.present(
            viewController,
            animated: animated,
            onDismissed: onDismissed
        )
    }
}

extension NewsListCoordinator: NewsListViewControllerDelegate {
    func didSelectArticle(_ viewController: NewsListViewController, _ article: Article) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        let coordinator = ArticleDetailCoordinator(router: router, article: article)
        presentChild(coordinator, animated: true, onDismissed: nil)
    }

    func didTapSearchButton() {
    }
}
