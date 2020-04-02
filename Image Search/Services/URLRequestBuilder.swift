//
//  URLRequestBuilder.swift
//  Image Search
//
//  Created by Paul Martens on 4/1/20.
//  Copyright © 2020 PM. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

class URLRequestBuilder {
    var scheme: String
    var host: String
    var path: String
    var method: HTTPMethod = .get
    var pathParams: [String: String]?
    var queryItems: [URLQueryItem]?
    var headers: [String: Any]?
    var body: [String: Any]?
    
    init(with scheme: String = "https", host: String = "api.unsplash.com", path: String) {
        self.scheme = scheme
        self.host = host
        self.path = path
    }
    
    func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    func set(path: String) -> Self {
        self.path = path
        return self
    }

    func set(headers: [String: Any]?) -> Self {
        self.headers = headers
        return self
    }
    
    func set(pathParams: [String: String]?) -> Self {
        self.pathParams = pathParams
        return self
    }
    
    func set(queryItems: [URLQueryItem]?) -> Self {
        self.queryItems = queryItems
        return self
    }
    
    func set(body: [String: Any]?) -> Self {
        self.body = body
        return self
    }
    
    func build() throws -> URLRequest {
        do {
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            // Insert path parameters
            var finalPath = path
            pathParams?.forEach {
                finalPath = finalPath.replacingOccurrences(of: $0.key, with: $0.value)
            }
            urlComponents.path = finalPath
            // Insert client id
            let clientId = URLQueryItem(name: "client_id", value: "ZrK1cbhlfzEWQjZYxI6FVUQ_-ECiXb5Y-he49q-SsvA")
            if var queryItems = queryItems {
                queryItems.append(clientId)
                urlComponents.queryItems = queryItems
            } else {
                urlComponents.queryItems = [clientId]
            }
            
            guard let url = urlComponents.url else {
                throw APIError.requestBuilderFailed
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            
            // If a body is provided serialize and add it to the request
            if let body = body {
                let jsonData = try? JSONSerialization.data(withJSONObject: body)
                urlRequest.httpBody = jsonData
            }
            
            // Apply headers if provided
            headers?.forEach {
                urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key)
            }
            
            urlRequest.addValue("v1", forHTTPHeaderField: "Accept-Version")
            
            return urlRequest
        } catch {
            throw APIError.requestBuilderFailed
        }
    }
}
