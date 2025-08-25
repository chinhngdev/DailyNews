//
//  NewsRouter.swift
//  DailyNews
//
//  Created by Chinh on 8/24/25.
//

import Foundation

enum NewsRouter: APIRouter {
    case everything
    case sources
    case topHeadlines

    var endpoint: String {
        switch self {
        case .everything:
            return "/everything"
        case .sources:
            return "/top-headlines/sources"
        case .topHeadlines:
            return "/top-headlines"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .everything, .sources, .topHeadlines:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .everything:
            return [:]
        case .sources:
            return [:]
        case .topHeadlines:
            return [:]
        }
    }
}
