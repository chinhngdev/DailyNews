//
//  AppCoordinator.swift
//  DailyNews
//
//  Created by Chinh on 8/6/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    var children: [Coordinator] = []
    let router: Router
    
    var tabBarController = UITabBarController()
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        setupTabs()
        router.present(tabBarController, animated: animated, onDismissed: onDismissed)
    }
    
    private func setupTabs() {
        let newsTab = createNewsTab()
        let favouriteTab = createFavouriteTab()
        let settingsTab = createSettingsTab()
        
        tabBarController.viewControllers = [
            newsTab,
            favouriteTab,
            settingsTab
        ]
    }
    
    private func createNewsTab() -> UINavigationController {
        let navController = UINavigationController()
        let navigationRouter = NavigationRouter(navigationController: navController)
        let newsCoordinator = NewsListCoordinator(router: navigationRouter)
        
        // Add to children and present
        children.append(newsCoordinator)
        newsCoordinator.present(animated: false, onDismissed: nil)
        
        navController.tabBarItem = UITabBarItem(
            title: L10n.tabbarNews,
            image: UIImage(systemName: "newspaper"),
            tag: 0
        )
        
        return navController
    }
    
    private func createFavouriteTab() -> UINavigationController {
        let navController = UINavigationController()
        let favouriteVC = FavouriteViewController()
        navController.setViewControllers([favouriteVC], animated: false)
        
        navController.tabBarItem = UITabBarItem(
            title: L10n.tabbarFavourite,
            image: UIImage(systemName: "star"),
            tag: 1
        )
        
        return navController
    }
    
    private func createSettingsTab() -> UINavigationController {
        let navController = UINavigationController()
        let settingsVC = SettingsViewController()
        navController.setViewControllers([settingsVC], animated: false)
        
        navController.tabBarItem = UITabBarItem(
            title: L10n.tabbarSettings,
            image: UIImage(systemName: "gear"),
            tag: 2
        )
        
        return navController
    }
}
