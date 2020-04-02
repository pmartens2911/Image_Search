//
//  SearchResponse.swift
//  Image Search
//
//  Created by Paul Martens on 4/1/20.
//  Copyright © 2020 PM. All rights reserved.
//

import UIKit

class SearchResponse: Codable {
    var total: Int
    var total_pages: Int
    var results: [PhotoDetails]
}

class PhotoDetails: Codable {
    var id: String
    var created_at: String
    var width: Int
    var height: Int
    var color: String
    var likes: Int
    var liked_by_user: Bool
    var description: String?
    var user: UserDetails
    var urls: PhotoUrls
    
    func thumbnailWidth() -> CGFloat {
        return 200.0
    }
    
    func thumbnailHeight() -> CGFloat {
        let aspectRatio = CGFloat(height) / CGFloat(width)
        return 200.0 * aspectRatio
    }
}

class PhotoUrls: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}

class UserDetails: Codable {
    var id: String
    var username: String?
    var name: String?
    var first_name: String?
    var last_name: String?
    var instagram_username: String?
    var twitter_username: String?
    var portfolio_url: String?
    var profile_image: ProfileImage?
    var links: ProfileLinks?
}

class ProfileImage: Codable {
    var small: String
    var medium: String
    var large: String
}

class ProfileLinks: Codable {
    var `self`: String
    var html: String
    var photos: String
    var likes: String
}

