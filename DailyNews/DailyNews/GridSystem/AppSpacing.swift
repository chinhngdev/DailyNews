//
//  AppSpacing.swift
//  DailyNews
//
//  Created by Chinh on 6/4/25.
//

import Foundation

enum AppSpacing: CGFloat {
    /// Minimal spacing: Border thickness, divider lines
    case minimal = 1
    
    /// Extra small: Text line spacing, icon padding, small gaps
    case extraSmall = 4

    /// Small: Component internal spacing, button padding
    case small = 8
    
    /// Medium small: List item spacing, form field gaps
    case mediumSmall = 12

    /// Medium: Between UI elements (most common), standard margins
    case medium = 16
    
    /// Medium large: Card internal padding, section spacing
    case mediumLarge = 20

    /// Large: Between sections, card spacing
    case large = 24
    
    /// Extra large: Screen margins, major section dividers
    case extraLarge = 32

    /// Extra extra large: Top/bottom screen margins, modal spacing
    case xxLarge = 40

    /// Extra extra extra large: Major layout spacing, hero sections
    case xxxLarge = 48
    
    /// Maximum: Special cases, full-screen spacing
    case maximum = 64

    var value: CGFloat {
        return self.rawValue
    }
    
    /// Convenience computed properties for common use cases
    static var screenMargin: CGFloat { AppSpacing.medium.value }
    static var cardPadding: CGFloat { AppSpacing.mediumLarge.value }
    static var sectionSpacing: CGFloat { AppSpacing.large.value }
    static var screenTopBottom: CGFloat { AppSpacing.xxxLarge.value }
}