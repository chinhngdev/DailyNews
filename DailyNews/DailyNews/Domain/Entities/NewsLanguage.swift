//
//  NewsLanguage.swift
//  DailyNews
//
//  Created by Chinh on 8/22/25.
//

import Foundation

enum NewsLanguage: String, CaseIterable {
    case arabic = "ar"
    case german = "de"
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case hebrew = "he"
    case italian = "it"
    case dutch = "nl"
    case norwegian = "no"
    case portuguese = "pt"
    case russian = "ru"
    case swedish = "sv"
    case urdu = "ud"
    case chinese = "zh"
    
    var displayName: String {
        switch self {
        case .arabic: return L10n.languageArabic
        case .german: return L10n.languageGerman
        case .english: return L10n.languageEnglish
        case .spanish: return L10n.languageSpanish
        case .french: return L10n.languageFrench
        case .hebrew: return L10n.languageHebrew
        case .italian: return L10n.languageItalian
        case .dutch: return L10n.languageDutch
        case .norwegian: return L10n.languageNorwegian
        case .portuguese: return L10n.languagePortuguese
        case .russian: return L10n.languageRussian
        case .swedish: return L10n.languageSwedish
        case .urdu: return L10n.languageUrdu
        case .chinese: return L10n.languageChinese
        }
    }
}
