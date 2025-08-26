//
//  NewsRouter.swift
//  DailyNews
//
//  Created by Chinh on 8/24/25.
//

import Foundation

enum NewsRouter: APIRouter {
    case everything(FetchNewsRequest)
    case sources
    case topHeadlines

    var endpoint: String {
        switch self {
        case .everything:
            return "/v2/everything"
        case .sources:
            return "/v2/top-headlines/sources"
        case .topHeadlines:
            return "/v2/top-headlines"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .everything, .sources, .topHeadlines:
            return .get
        }
    }

    var task: RequestTask {
        switch self {
        case .everything(let request):
            return .requestParameters([
                "q": request.query,
                "sortBy": request.sortBy(),
                "pageSize": request.pageSize,
                "page": request.page
            ])
        case .sources, .topHeadlines:
            return .requestPlain
        }
    }
}
