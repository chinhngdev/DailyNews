//
//  NewsCategory.swift
//  DailyNews
//
//  Created by Chinh on 8/22/25.
//

import Foundation

enum NewsCategory: String, CaseIterable {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"

    var displayName: String {
        switch self {
        case .business: return L10n.newsCategoryBusiness
        case .entertainment: return L10n.newsCategoryEntertainment
        case .general: return L10n.newsCategoryGeneral
        case .health: return L10n.newsCategoryHealth
        case .science: return L10n.newsCategoryScience
        case .sports: return L10n.newsCategorySports
        case .technology: return L10n.newsCategoryTechnology
        }
    }
}
