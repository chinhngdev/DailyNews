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
            return request
            
        case .requestParameters(let parameters):
            return try request.encoded(urlParameters: parameters)
            
        case .requestData(let data):
            request.httpBody = data
            return request
            
        case .requestJSONEncodable(let encodable):
            return try request.encoded(encodable: encodable, encoder: JSONEncoder())
            
        case .requestCustomJSONEncodable(let encodable, let encoder):
            return try request.encoded(encodable: encodable, encoder: encoder)
            
        case .requestCompositeData(let bodyData, let urlParameters):
            request.httpBody = bodyData
            return try request.encoded(urlParameters: urlParameters)
            
        case .requestCompositeParameters(let bodyParameters, let urlParameters):
            request = try request.encoded(urlParameters: urlParameters)
            return try request.encoded(parameters: bodyParameters)
        }
    }

}
