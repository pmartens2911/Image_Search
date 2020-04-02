//
//  ServiceAPI.swift
//  Image Search
//
//  Created by Paul Martens on 4/1/20.
//  Copyright © 2020 PM. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestBuilderFailed
}

enum OrderBy: String {
    case relevant, latest
}

class ServiceAPI {
    static let shared = ServiceAPI()
    private init() {}
    
    let urlSession = URLSession.shared
    
    func getSearchResults(query: String, orderBy: OrderBy = .relevant, completion: @escaping (Data?, Error?) -> Void) {
        let path = "/search/photos"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "order_by", value: orderBy.rawValue),
            URLQueryItem(name: "per_page", value: "25")
        ]
        do {
            let request = try URLRequestBuilder(path: path)
                .set(queryItems: queryItems)
                .build()
            urlSession.dataTask(with: request) { (data, response, error) in
                completion(data, error)
            }.resume()
        } catch  {
            completion(nil, error)
        }
    }
    
    func getPhotos(completion: @escaping (Data?, Error?) -> Void) {
        let path = "/photos"
        do {
            let request = try URLRequestBuilder(path: path)
                .build()
            urlSession.dataTask(with: request) { (data, response, error) in
                completion(data, error)
            }.resume()
        } catch  {
            completion(nil, error)
        }
        
    }
    
}
