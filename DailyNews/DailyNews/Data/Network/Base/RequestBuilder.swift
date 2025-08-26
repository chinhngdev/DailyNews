//
//  RequestBuilder.swift
//  DailyNews
//
//  Created by Chinh on 8/25/25.
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

protocol RequestBuilderProtocol {
    func buildRequest(from router: APIRouter) throws -> URLRequest
}

final class RequestBuilder: RequestBuilderProtocol {
    func buildRequest(from router: APIRouter) throws -> URLRequest {
        let fullURL = router.baseURL + router.endpoint
        
        guard let url = URL(string: fullURL) else {
            throw RequestBuilderError.invalidURL
        }

        return try configureRequest(router, with: router.task, url: url)
    }
    
    private func configureRequest(_ router: APIRouter, with task: RequestTask, url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        request.timeoutInterval = APIConfiguration.apiTimeout
        
        // Add headers
        router.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        switch task {
        case .requestPlain:
            // No additional configuration needed
            break
            
        case .requestParameters(let parameters):
            try addURLParameters(to: &request, parameters: parameters)
            
        case .requestData(let data):
            request.httpBody = data
            
        case .requestJSONEncodable(let encodable):
            try addJSONBody(to: &request, encodable: encodable, encoder: JSONEncoder())
            
        case .requestCustomJSONEncodable(let encodable, let encoder):
            try addJSONBody(to: &request, encodable: encodable, encoder: encoder)
            
        case .requestCompositeData(let bodyData, let urlParameters):
            try addURLParameters(to: &request, parameters: urlParameters)
            request.httpBody = bodyData
            
        case .requestCompositeParameters(let bodyParameters, let urlParameters):
            try addURLParameters(to: &request, parameters: urlParameters)
            try addJSONBody(to: &request, parameters: bodyParameters)
        }

        return request
    }
    
    private func addURLParameters(to request: inout URLRequest, parameters: [String: Any]) throws {
        guard let url = request.url else {
            throw RequestBuilderError.invalidURL
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = parameters.map { 
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        guard let finalURL = urlComponents?.url else {
            throw RequestBuilderError.invalidURL
        }
        request.url = finalURL
    }
    
    private func addJSONBody(to request: inout URLRequest, encodable: Encodable, encoder: JSONEncoder) throws {
        do {
            request.httpBody = try encoder.encode(encodable)
        } catch {
            throw RequestBuilderError.invalidData
        }
    }
    
    private func addJSONBody(to request: inout URLRequest, parameters: [String: Any]) throws {
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw RequestBuilderError.invalidData
        }
    }
}
