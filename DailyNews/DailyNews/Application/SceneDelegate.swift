//
//  SceneDelegate.swift
//  DailyNews
//
//  Created by Chinh on 6/4/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    private lazy var router: SceneDelegateRouter = {
        return SceneDelegateRouter(windowScene: windowScene!)
    }()
    
    private lazy var coordinator: NewsListCoordinator = {
        return NewsListCoordinator(router: router)
    }()
    
    var window: UIWindow? {
        get { return router.window }
        set { /* ignore setter because window is managed by router */ }
    }
    
    private var windowScene: UIWindowScene?

    // MARK: - Scene lifecycle methods
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure scene is UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.windowScene = windowScene
        
        // Create root navigation controller
        let newsListVC = NewsListViewController.instantiate(delegate: coordinator)
        let navController = UINavigationController(rootViewController: newsListVC)
        
        router.present(navController, animated: false, onDismissed: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

