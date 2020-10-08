//
//  HomeCarrousselView.swift
//  MarvelList
//
//  Created by MacDev on 07/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit
import SnapKit

class HomeCarrousselView: UIView {
    
    @IBOutlet weak var stackItems: UIStackView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
        
    var model: HomeModels.HomeViewModel? {
        didSet {
            self.layoutIfNeeded()
            self.setupLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
    
    func setupLayout() {
        
        guard let viewModel = self.model else {
            return
        }
        
        scrollView.delegate = self
        pageControl.numberOfPages = viewModel.carroussel.count
        
        for hero in viewModel.carroussel {
            let carrousselItem = HomeCarrousselItemView.instanceFromNib()
            stackItems.addArrangedSubview(carrousselItem)
            
            carrousselItem.snp.makeConstraints { make in
                make.height.equalToSuperview()
                make.width.equalTo(UIScreen.main.bounds.width)
            }
            
            carrousselItem.setupLayout(hero: hero)
        }
    }
        
}

extension HomeCarrousselView: UIScrollViewDelegate {
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let currentPage = scrollView.currentPage
            pageControl.currentPage = currentPage
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.currentPage
        pageControl.currentPage = currentPage
    }
}

extension HomeCarrousselView {
    class func instanceFromNib() -> HomeCarrousselView {
        return UINib(nibName: "HomeCarrousselView", bundle: nil).instantiate(withOwner: self, options: nil).first as! HomeCarrousselView
    }
}
