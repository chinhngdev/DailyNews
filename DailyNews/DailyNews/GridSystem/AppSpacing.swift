//
//  AppSpacing.swift
//  DailyNews
//
//  Created by Chinh on 6/4/25.
//

import Foundation

enum AppSpacing: CGFloat {
    /// Text line spacing, icon padding
    case extraSmall = 4

    /// Component internal spacing
    case small = 8

    /// Between UI elements (most common)
    case medium = 16

    /// Between sections
    case large = 24

    /// Extra large: Screen margins, card spacing
    case extraLarge = 32

    /// Extra extra large: Section dividers
    case xxLarge = 40

    /// Extra extra extra large: Top/bottom screen margins
    case xxxLarge = 48

    var value: CGFloat {
        return self.rawValue
    }
}