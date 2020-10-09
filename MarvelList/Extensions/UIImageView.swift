//
//  UIImageView.swift
//  MarvelList
//
//  Created by MacDev on 08/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {

    func load(url: String, completion: @escaping ((_ image: UIImage?) -> Void)) {
        
        if url.lowercased().contains("image_not_available") {
            completion(nil)
            return
        }
        
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
         self.sd_setImage(with: url) { (image, error, cache, urls) in
            guard let img = image, error == nil else {
                completion(nil)
                return
            }
            completion(img)
        }

    }
    
    func cancelRequest() {
        self.sd_cancelCurrentImageLoad()
    }
    
    class func getDefaultImage() -> UIImage {
        return UIImage(named: "image_not_available", in: nil, compatibleWith: nil) ?? UIImage()
    }
    
}
