//
//  APIRouter.swift
//  DailyNews
//
//  Created by Chinh on 8/25/25.
//

import Foundation

protocol APIRouter {
    var baseURL: String { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var task: RequestTask { get }
    var headers: [String: String]? { get }
}

extension APIRouter {
    var baseURL: String {
        APIKeys.newsAPIBaseURL
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Authorization": "\(APIKeys.newsAPIKey)"
        ]
    }
}
