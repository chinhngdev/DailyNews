//
//  RequestBuilderError.swift
//  DailyNews
//
//  Created by Chinh on 8/26/25.
//

import Foundation

enum RequestBuilderError: Error, LocalizedError {
    case invalidURL
    case invalidData
    case invalidRequest

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidData:
            return "Invalid data"
        case .invalidRequest:
            return "Invalid request"
        }
    }
}
