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
    
    func showNewsDetail(_ article: Article) {
        print("Did tap on article: \(article.title)")
    }
    
    func showSearch() {
        print("Did tap on search button")
    }
}

extension NewsListCoordinator: NewsListViewControllerDelegate {
    func didSelectArticle(_ article: Article) {
        showNewsDetail(article)
    }

    func didTapSearchButton() {
        showSearch()
    }
}
