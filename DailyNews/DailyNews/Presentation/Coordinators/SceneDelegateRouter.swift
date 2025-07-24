//
//  SceneDelegateRouter.swift
//  DailyNews
//
//  Created by Chinh on 7/24/25.
//

import UIKit

final class SceneDelegateRouter {
    // MARK: - Properties
    public let windowScene: UIWindowScene
    public lazy var window: UIWindow = UIWindow(windowScene: windowScene)
    
    // MARK: - Initialization
    public init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }
}

// MARK: - Router
extension SceneDelegateRouter: Router {
    func present(
        _ viewController: UIViewController,
        animated: Bool,
        onDismissed: (() -> Void)? = nil
    ) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func dismiss(animated: Bool) {
        // This router will be held onto by the SceneDelegate directly and isn't meant to be dismissible. Thereby, you simply ignore calls to dismiss(animated:).
    }
}
