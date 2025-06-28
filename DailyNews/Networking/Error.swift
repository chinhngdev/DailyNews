//
//  Error.swift
//  DailyNews
//
//  Created by Chinh on 6/28/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case noData
    case unknownError
    case invalidStatusCode(Int)

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        case .unknownError:
            return "An unknown error occurred"
        case .invalidStatusCode(let code):
            return "Invalid status code: \(code)"
        }
    }
}
