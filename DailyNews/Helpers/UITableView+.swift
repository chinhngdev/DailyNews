//
//  UITableView+.swift
//  DailyNews
//
//  Created by Chinh on 7/21/25.
//

import UIKit

extension UITableViewCell: Reusable {}

extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type,
                                               for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier,
                                           for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
        }
        return cell
    }
}
