//
//  NewsError.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

import Foundation

enum NewsError: Int, Error {
    case badRequest
    case unauthorized
    case tooManyRequests
    case serverError

    // MARK: - Additional cases
    case invalidURL
    case invalidResponse
    case invalidData

    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unauthorized"
        case .tooManyRequests:
            return "Too many requests"
        case .serverError:
            return "Server error"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        }
    }
}
