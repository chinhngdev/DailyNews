//
//  NewsError.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

import Foundation

enum NewsError: Error {
    case invalidURL
    case invalidResponse
    case invalidData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        }
    }
}
