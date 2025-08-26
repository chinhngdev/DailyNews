//
//  URLRequest+Encoding.swift
//  DailyNews
//
//  Created by Chinh on 8/26/25.
//

import Foundation

extension URLRequest {
    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            httpBody = try encoder.encode(encodable)
            
            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }
            
            return self
        } catch {
            throw RequestBuilderError.invalidData
        }
    }
    
    mutating func encoded(parameters: [String: Any]) throws -> URLRequest {
        do {
            httpBody = try JSONSerialization.data(withJSONObject: parameters)
            
            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }
            
            return self
        } catch {
            throw RequestBuilderError.invalidData
        }
    }
    
    mutating func encoded(urlParameters: [String: Any]) throws -> URLRequest {
        guard let url = url else {
            throw RequestBuilderError.invalidURL
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = urlParameters.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        guard let finalURL = urlComponents?.url else {
            throw RequestBuilderError.invalidURL
        }
        
        self.url = finalURL
        return self
    }
}
