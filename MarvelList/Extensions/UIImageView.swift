//
//  UIImageView.swift
//  MarvelList
//
//  Created by MacDev on 08/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

extension UIImageView {

    func load(url: String, completion: @escaping ((_ image: UIImage?) -> Void)) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if error != nil {
                    completion(nil)
                    return
                }
                guard let image = UIImage(data: data!) else {
                    completion(nil)
                    return
                }
                completion(image)
            })
        }).resume()
    }
    
    class func getDefaultImage() -> UIImage {
        return UIImage(named: "image_not_available", in: nil, compatibleWith: nil) ?? UIImage()
    }
    
}
