//
//  AppCoordinator.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showNewsList()
    }
    
    private func showNewsList() {
        let newsListCoordinator = NewsListCoordinator(navigationController: navigationController)
        newsListCoordinator.parentCoordinator = self
        childCoordinators.append(newsListCoordinator)
        newsListCoordinator.start()
    }
}
