//
//  AppFont.swift
//  DailyNews
//
//  Created by Chinh on 7/21/25.
//

import UIKit

enum AppFont {
    /// for navigation and section titles
    case title

    /// for article titles
    case headline

    /// for main text content
    case body

    /// for small text like source/time
    case caption

    /// for big headings
    case largeTitle
    
    var font: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.systemFont(ofSize: 22, weight: .bold)
        case .title:
            return UIFont.systemFont(ofSize: 17, weight: .semibold)
        case .headline:
            return UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .body:
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .caption:
            return UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
}