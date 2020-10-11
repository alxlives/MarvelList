//
//  HomeCarrousselItemView.swift
//  MarvelList
//
//  Created by MacDev on 07/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

protocol HomeCarrousselItemViewProtocol {
    func imageDidLoad(_ image:UIImage, hero: HomeModels.HomeViewModel.Hero)
}

class HomeCarrousselItemView: UIView {
    //MARK: - Properties
    private var hero: HomeModels.HomeViewModel.Hero
    var delegate: HomeCarrousselItemViewProtocol?

    //MARK: - Views
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.insetsLayoutMarginsFromSafeArea = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    private lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .black)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.text = hero.name
        lbl.textColor = Constants.Color.labelColor
        lbl.layer.shadowColor = Constants.Color.glowColor.cgColor
        lbl.layer.shadowOffset = .zero
        lbl.layer.shadowRadius = 5.0
        lbl.layer.shadowOpacity = 1.0
        lbl.layer.masksToBounds = false
        lbl.layer.shouldRasterize = true
        return lbl
    }()
    
    //MARK: - Init
    init (_ hero: HomeModels.HomeViewModel.Hero) {
        self.hero = hero
        super.init(frame: .zero)
        setupView()
        loadImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCarrousselItemView: ViewCodeProtocol {
    func setupHierarchy() {
        addSubview(imgView)
        addSubview(lblName)
    }
    
    func setupConstraints() {
        imgView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        lblName.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension HomeCarrousselItemView {
    
    func loadImage() {
        imgView.load(url: hero.thumbUrl ?? "", completion: { (image) in
            if let img = image {
                self.imgView.image = img
                self.delegate?.imageDidLoad(img, hero: self.hero)
            } else {
                self.imgView.image = UIImageView.getDefaultImage()
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.imgView.alpha = 1
            })
        })
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            lblName.layer.shadowColor = Constants.Color.glowColor.cgColor
        }
    }

}
