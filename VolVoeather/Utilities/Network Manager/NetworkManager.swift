//
//  NetworkManager.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/8/22.
//

import Foundation
import Combine


enum APIError: Error {
    case invalidBody
    case invalidEndpoint
    case invalidURL
    case emptyData
    case invalidJSON
    case invalidResponse
    case statusCode(Int)
}


class NetworkManager {
    static func getRequest(url: String, cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy) throws -> URLSession.DataTaskPublisher {
//        let headers = [
//            "Content-Type": "application/json"
//        ]
        guard let url = URL(string: url) else {
            throw APIError.invalidURL
        }
        
        
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        return session.dataTaskPublisher(for: request)
    }
}


