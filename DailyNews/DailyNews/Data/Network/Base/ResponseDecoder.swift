//
//  ResponseDecoder.swift
//  DailyNews
//
//  Created by Chinh on 8/25/25.
//

import Foundation

protocol ResponseDecoderProtocol {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

enum ResponseDecoderError: Error, LocalizedError {
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}

final class JSONResponseDecoder: ResponseDecoderProtocol {
    private let decoder: JSONDecoder

    init(
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) {
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = dateDecodingStrategy
        self.decoder.keyDecodingStrategy = keyDecodingStrategy
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw ResponseDecoderError.decodingError(error)
        }
    }
}
