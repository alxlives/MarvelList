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
    //MARK: - Constants
    private let carrousselTime = 3.0
    
    //MARK: - Properties
    var model: HomeModels.HomeViewModel
    private var timer: Timer?
    
    //MARK: - Views
    private lazy var stackItems: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0.0
        return stack
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = model.carroussel.count
        return pageControl
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
 
    //MARK: - Init
    init (_ model: HomeModels.HomeViewModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: ViewCodeProtocol
extension HomeCarrousselView: ViewCodeProtocol {
    func setupHierarchy() {
        scrollView.addSubview(stackItems)
        self.addSubview(scrollView)
        self.addSubview(pageControl)
    }
    
    func setupConstraints() {
        pageControl.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        stackItems.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func aditionalSetup() {
        for hero in model.carroussel {
            let carrousselItem = HomeCarrousselItemView(hero)
            stackItems.addArrangedSubview(carrousselItem)

            carrousselItem.snp.makeConstraints { make in
                make.height.equalToSuperview()
                make.width.equalTo(UIScreen.main.bounds.width)
            }
        }
        
        startTimer()
    }
    
    func startTimer() {
        timer = Timer(timeInterval: carrousselTime, repeats: true, block: { _ in
            self.scrollView.moveToNextPage(onCompletion: {
                self.pageControl.currentPage = self.scrollView.currentPage
            })
        })
        RunLoop.main.add(timer!, forMode: .common)
    }

}
    
// MARK: UIScrollViewDelegate
extension HomeCarrousselView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.currentPage
        startTimer()
    }
    
}
