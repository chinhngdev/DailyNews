//
//  ArticleDetailCoordinator.swift
//  DailyNews
//
//  Created by Chinh on 7/24/25.
//

import Foundation

final class ArticleDetailCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    let router: Router

    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = ArticleDetailViewController.instantiate()
        router.present(
            viewController,
            animated: animated,
            onDismissed: onDismissed
        )
    }
}
