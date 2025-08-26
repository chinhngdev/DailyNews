//
//  NetworkResponse.swift
//  DailyNews
//
//  Created by Chinh on 8/26/25.
//

import Foundation

struct NetworkResponse<T: Decodable> {
    let data: T?
    let statusCode: Int
    let rawData: Data
}
