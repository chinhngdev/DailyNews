//
//  Coordinator.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var router: Router { get }
    
    func present(animated: Bool, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?)
}

// MARK: - Default implementation
extension Coordinator {
    func dismiss(animated: Bool) {
        router.dismiss(animated: animated)
    }
    
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?) {
        children.append(child)
        child.present(animated: animated) { [weak self, weak child] in
            guard let self = self,
                  let child = child
            else { return }
            self.removeChild(child)
            onDismissed?()
        }
    }
    
    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: { $0 === child }) else {
            return
        }
        children.remove(at: index)
    }
}
