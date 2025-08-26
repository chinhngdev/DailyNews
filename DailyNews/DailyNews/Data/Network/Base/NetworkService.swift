//
//  NetworkService.swift
//  DailyNews
//
//  Created by Chinh on 8/25/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ router: APIRouter, responseType: T.Type) async throws -> NetworkResponse<T>
}

final class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let requestBuilder: RequestBuilderProtocol
    private let responseDecoder: ResponseDecoderProtocol
    
    init(
        urlSession: URLSession = .shared,
        requestBuilder: RequestBuilderProtocol = RequestBuilder(),
        responseDecoder: ResponseDecoderProtocol = JSONResponseDecoder()
    ) {
        self.urlSession = urlSession
        self.requestBuilder = requestBuilder
        self.responseDecoder = responseDecoder
    }
    
    func request<T: Decodable>(_ router: APIRouter, responseType: T.Type) async throws -> NetworkResponse<T> {
        do {
            let request = try requestBuilder.buildRequest(from: router)
            
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // Only attempt to decode data if the status code indicates success
            let decodedData: T? = {
                if (200...299).contains(httpResponse.statusCode) {
                    do {
                        return try responseDecoder.decode(responseType, from: data)
                    } catch {
                        // Don't throw here, let the caller decide based on status code
                        return nil
                    }
                }
                return nil
            }()
            
            return NetworkResponse(
                data: decodedData,
                statusCode: httpResponse.statusCode,
                rawData: data
            )
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
