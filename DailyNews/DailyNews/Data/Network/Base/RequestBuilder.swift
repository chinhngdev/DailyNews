//
//  RequestBuilder.swift
//  DailyNews
//
//  Created by Chinh on 8/25/25.
//

import Foundation

protocol RequestBuilderProtocol {
    func buildRequest(from router: APIRouter) throws -> URLRequest
}

final class RequestBuilder: RequestBuilderProtocol {
    func buildRequest(from router: APIRouter) throws -> URLRequest {
        let fullURL = router.baseURL + router.endpoint
        
        guard let url = URL(string: fullURL) else {
            throw NewsError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        request.timeoutInterval = APIConfiguration.apiTimeout
        
        // Add headers
        router.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add query parameters for GET requests
        if router.method == .get, let parameters = router.parameters, !parameters.isEmpty {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map { 
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            
            guard let finalURL = urlComponents?.url else {
                throw NewsError.invalidURL
            }
            request.url = finalURL
        }
        
        return request
    }
}
