//
//  ArticleDetailCoordinator.swift
//  DailyNews
//
//  Created by Chinh on 7/24/25.
//

import UIKit

final class ArticleDetailCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    let router: Router
    private let article: Article

    init(router: Router, article: Article) {
        self.router = router
        self.article = article
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewModel = ArticleDetailViewModel(article: article)
        let viewController = ArticleDetailViewController.instantiate(with: viewModel)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}
