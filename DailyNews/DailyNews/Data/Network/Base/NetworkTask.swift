//
//  NetworkTask.swift
//  DailyNews
//
//  Created by ChinhNT on 8/25/25.
//

import Foundation

enum NetworkTask {
    /// A request with no additional data
    case requestPlain
    
    /// URL query parameters for GET
    case requestParameters([String: Any])
    
    /// Raw data for body
    case requestData(Data)
    
    /// JSON encodable object
    case requestJSONEncodable(Encodable)
    
    /// Custom JSON encoder
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
    
    /// Both body and URL params
    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])
    
    /// Both types of params
    case requestCompositeParameters(bodyParameters: [String: Any], urlParameters: [String: Any])
}
