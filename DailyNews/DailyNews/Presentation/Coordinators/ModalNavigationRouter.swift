//
//  ModalNavigationRouter.swift
//  DailyNews
//
//  Created by Chinh on 7/24/25.
//

import UIKit

// MARK: - ModalNavigationRouter
public class ModalNavigationRouter: NSObject {
    // MARK: - Properties
    public unowned let parentViewController: UIViewController
    private let navigationController = UINavigationController()
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    // MARK: - Initialization
    public init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
        navigationController.delegate = self
    }
}

// MARK: - Router
extension ModalNavigationRouter: Router {
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        
        if navigationController.viewControllers.count == 0 {
            presentModally(viewController, animated: animated)
        } else {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    func dismiss(animated: Bool) {
        performOnDismissed(for: navigationController.viewControllers.first!)
        
        // Dismiss modal navigation controller
        parentViewController.dismiss(animated: animated, completion: nil)
    }
    
    // MARK: - Private Methods
    private func presentModally(_ viewController: UIViewController, animated: Bool) {
        // Add Cancel button for modal presentation
        addCancelButton(to: viewController)
        
        // Set view controller as root of navigation controller
        navigationController.setViewControllers([viewController], animated: false)
        
        // Present navigation controller modally
        parentViewController.present(
            navigationController,
            animated: animated,
            completion: nil
        )
    }
    
    private func addCancelButton(to viewController: UIViewController) {
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: L10n.commonCancel,
            style: .plain,
            target: self,
            action: #selector(cancelPressed)
        )
    }
    
    @objc private func cancelPressed() {
        performOnDismissed(for: navigationController.viewControllers.first!)
        dismiss(animated: true)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else {
            return
        }
        
        // Execute closure then remove
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

// MARK: - UINavigationControllerDelegate
extension ModalNavigationRouter: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(dismissedViewController) else {
            return
        }
        
        performOnDismissed(for: dismissedViewController)
    }
}
