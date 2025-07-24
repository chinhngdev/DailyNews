//
//  Router.swift
//  DailyNews
//
//  Created by Chinh on 7/24/25.
//

import UIKit

// MARK: - Router Protocol
protocol Router {
    // Present methods
    func present(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?)
    
    // Dismiss the entire router
    func dismiss(animated: Bool)
}

extension Router {
    func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismissed: nil)
    }
}
