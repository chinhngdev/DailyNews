//
//  NetworkService.swift
//  DailyNews
//
//  Created by Chinh on 8/25/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ router: APIRouter, responseType: T.Type) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let requestBuilder: RequestBuilderProtocol
    
    init(
        urlSession: URLSession = .shared,
        requestBuilder: RequestBuilderProtocol = RequestBuilder()
    ) {
        self.urlSession = urlSession
        self.requestBuilder = requestBuilder
    }
    
    func request<T: Decodable>(_ router: APIRouter, responseType: T.Type) async throws -> T {
        let request = try requestBuilder.buildRequest(from: router)
        
        let (data, response) = try await urlSession.data(for: request)
        
        // Validate response
        try validateResponse(response)
        
        // Decode JSON
        let decoder = JSONDecoder()
        return try decoder.decode(responseType, from: data)
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NewsError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NewsError.unauthorized
        case 429:
            throw NewsError.tooManyRequests
        case 500:
            throw NewsError.serverError
        default:
            throw NewsError.invalidResponse
        }
    }
}
