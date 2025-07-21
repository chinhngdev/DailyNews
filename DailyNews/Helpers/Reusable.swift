//
//  Reusable.swift
//  DailyNews
//
//  Created by Chinh on 7/21/25.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
