//
//  NewsListCoordinator.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import UIKit

protocol NewsListCoordinatorDelegate: AnyObject {
    func newsListCoordinatorDidFinish(_ coordinator: NewsListCoordinator)
}

final class NewsListCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let newsListVC = NewsListViewController()
        newsListVC.coordinator = self
        navigationController.pushViewController(newsListVC, animated: false)
    }
    
    func showNewsDetail(_ article: Article) {}
    
    func showSearch() {}
}
