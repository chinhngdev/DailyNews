//
//  NewsRouter.swift
//  DailyNews
//
//  Created by Chinh on 8/24/25.
//

import Foundation

enum NewsRouter: APIRouter {
    case everything(FetchNewsRequestParams)
    case newsSources(NewsSourceRequest)
    case topHeadlines

    var endpoint: String {
        switch self {
        case .everything:
            return "/v2/everything"
        case .newsSources:
            return "/v2/top-headlines/sources"
        case .topHeadlines:
            return "/v2/top-headlines"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .everything, .newsSources, .topHeadlines:
            return .get
        }
    }

    var task: NetworkTask {
        switch self {
        case .everything(let request):
            return .requestParameters([
                "q": request.query,
                "sortBy": request.sortBy(),
                "pageSize": request.pageSize,
                "page": request.page
            ])
        case .newsSources(let request):
            return .requestParameters([
                "country": request.country ?? "us",
                "category": request.category ?? "general",
                "language": request.language ?? "en"
            ])
        case .topHeadlines:
            return .requestPlain
        }
    }
}
