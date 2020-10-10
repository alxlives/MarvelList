//
//  HomeTableViewCell.swift
//  MarvelList
//
//  Created by MacDev on 08/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    //MARK: - Properties
    private var hero: HomeModels.HomeViewModel.Hero?
    var delegate: HomeViewScreenPersistanceProtocol?
    
    //MARK: - Views
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        return imageView
    }()
    
    private lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    //MARK: - Init
    func setupHero(_ hero: HomeModels.HomeViewModel.Hero) {
        self.hero = hero
        setupView()
        checkCacheImage()
    }
    
    override func prepareForReuse() {
        imgView.cancelRequest()
        imgView.image = nil
        imgView.alpha = 0
        lblName.text = ""
    }
    
}

//MARK: - ViewCodeProtocol
extension HomeTableViewCell: ViewCodeProtocol {
    
    func setupHierarchy() {
        addSubview(imgView)
        addSubview(lblName)
    }
    
    func setupConstraints() {
        imgView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(50)
            make.height.equalTo(50).priority(.high)
        }
        
        lblName.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(imgView.snp.trailing).inset(-8)
        }
    }
    
    func aditionalSetup() {
        self.backgroundColor = .white
        lblName.text = hero?.name
    }
}

//MARK: - Image Loading + Animations
extension HomeTableViewCell {
    private func checkCacheImage() {
        if let cacheImage = hero?.image {
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
