//
//  HomeTableViewCell.swift
//  MarvelList
//
//  Created by MacDev on 08/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

protocol HomeTableViewCellProtocol {
    func imageDidLoad(_ image:UIImage, hero: HomeModels.HomeViewModel.Hero)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var hero: HomeModels.HomeViewModel.Hero?
    
    var delegate: HomeTableViewCellProtocol?
    
    func setupHero(_ hero: HomeModels.HomeViewModel.Hero) {
        
        self.hero = hero
        lblName.text = hero.name
        
        self.imgView.alpha = 0
        
        if let cacheImage = hero.image {
            self.imgView.image = cacheImage
            self.animateAlpha()
        } else {
            loadImage()
        }
        
    }
    
    func loadImage() {
        guard let hero = self.hero else {
            return
        }
        
        imgView.load(url: hero.thumbUrl ?? "", completion: { (image) in
           
            if let img = image {
                self.imgView.image = img
                self.delegate?.imageDidLoad(img, hero: hero)
            } else {
                self.imgView.image = UIImageView.getDefaultImage()
            }
            
            self.animateAlpha()
        })
    }
    
    func animateAlpha() {
        UIView.animate(withDuration: 0.5, animations: {
            self.imgView.alpha = 1
        })
    }
}

extension HomeTableViewCell {
    class func instanceFromNib() -> HomeTableViewCell {
        return UINib(nibName: "HomeTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).first as! HomeTableViewCell
    }
}
