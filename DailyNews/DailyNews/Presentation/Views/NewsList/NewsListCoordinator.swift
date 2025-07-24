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
        let viewController = NewsListViewController.instantiate()
        router.present(
            viewController,
            animated: animated,
            onDismissed: onDismissed
        )
    }
    
    func showNewsDetail(_ article: Article) {}
    
    func showSearch() {}
}
