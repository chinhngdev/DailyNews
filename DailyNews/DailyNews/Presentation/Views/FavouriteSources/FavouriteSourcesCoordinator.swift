//
//  FavouriteSourcesCoordinator.swift
//  DailyNews
//
//  Created by Chinh on 8/21/25.
//

import UIKit

final class FavouriteSourcesCoordinator: Coordinator {
    var children: [Coordinator] = []
    let router: Router

    init(router: Router) {
        self.router = router
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {}
}

extension FavouriteSourcesCoordinator: FavouriteSourcesViewControllerDelegate {}
