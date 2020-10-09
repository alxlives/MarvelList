//
//  UIScrollView.swift
//  MarvelList
//
//  Created by MacDev on 08/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)
    }
    
    var numberOfPages: Int {
        return Int(self.frame.size.width/self.frame.width)
    }
    
    func moveToNextPage(onCompletion : @escaping (() -> Void)) {
        let offset = contentOffset.x + self.frame.width
        let rectX:CGFloat = offset >= self.contentSize.width ? 0 : CGFloat(offset)
        UIView.animate(withDuration: 1.0, animations: {
            self.scrollRectToVisible(CGRect(x: rectX, y: CGFloat(0.0), width: self.frame.size.width, height: self.frame.size.height), animated: false)
        }, completion: { _ in
            onCompletion()
        })
    }
}
