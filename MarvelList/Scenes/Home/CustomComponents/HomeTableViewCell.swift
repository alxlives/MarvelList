//
//  HomeTableViewCell.swift
//  MarvelList
//
//  Created by MacDev on 08/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    func setupHero(_ hero: HomeModels.HomeViewModel.Heroe) {
        
        lblName.text = hero.name
        
        imgView.load(url: hero.thumb ?? "", completion: { (image) in
            self.imgView.alpha = 0
            self.imgView.image = image
            
            UIView.animate(withDuration: 0.5, animations: {
                self.imgView.alpha = 1
            })
        })
        
    }
}

extension HomeTableViewCell {
    class func instanceFromNib() -> HomeTableViewCell {
        return UINib(nibName: "HomeTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).first as! HomeTableViewCell
    }
}

