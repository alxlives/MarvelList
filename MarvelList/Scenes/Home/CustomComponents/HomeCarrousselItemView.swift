//
//  HomeCarrousselItemView.swift
//  MarvelList
//
//  Created by MacDev on 07/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

class HomeCarrousselItemView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    func setupLayout(hero: HomeModels.HomeViewModel.Heroe) {
        
        lblName.text = hero.name
        lblName.layer.shadowColor = UIColor.white.cgColor
        lblName.layer.shadowOffset = .zero
        lblName.layer.shadowRadius = 5.0
        lblName.layer.shadowOpacity = 1.0
        lblName.layer.masksToBounds = false
        lblName.layer.shouldRasterize = true
        
        imageView.load(url: hero.thumb ?? "", completion: { (image) in
            self.imageView.alpha = 0
            self.imageView.image = image
            
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.alpha = 1
            })
        })
        
    }
}

extension HomeCarrousselItemView {
    class func instanceFromNib() -> HomeCarrousselItemView {
        return UINib(nibName: "HomeCarrousselItemView", bundle: nil).instantiate(withOwner: self, options: nil).first as! HomeCarrousselItemView
    }
}
