//
//  UICollectionView+.swift
//  DailyNews
//
//  Created by Chinh on 7/21/25.
//

import Foundation
import UIKit

extension UICollectionViewCell: Reusable {}

extension UICollectionView {
    // Register cell
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    // Register XIB cell
    func registerNib<T: UICollectionViewCell>(_ cellType: T.Type) {
        let nib = UINib(nibName: cellType.reuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    // Dequeue cell
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type,
                                                    for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier,
                                           for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
        }
        return cell
    }
}
