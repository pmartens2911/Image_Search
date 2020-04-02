//
//  UIImageView+Extension.swift
//  Image Search
//
//  Created by Paul Martens on 4/1/20.
//  Copyright © 2020 PM. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    if let imageToCache = self.image {
                        imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    }
                }
            }
        }.resume()
    }
}
