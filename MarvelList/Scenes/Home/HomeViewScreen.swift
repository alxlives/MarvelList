//
//  HomeViewScreen.swift
//  MarvelList
//
//  Created by MacDev on 09/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit
import SnapKit

protocol HomeViewScreenProtocol {
    func saveImage(_ image:UIImage, forIndex index: Int, at: HomeModels.HomePersistance)
    func requestMoreHeroes()
}

protocol HomeViewScreenPersistanceProtocol {
    func imageDidLoad(_ image:UIImage, hero: HomeModels.HomeViewModel.Hero)
}

class HomeViewScreen: UIView {
    //MARK: - Constants
    private let carrousselHeight = Constants.Carroussel.height
    
    //MARK: - Variables
    var model: HomeModels.HomeViewModel
    var isLoadingNextPage = false
    var delegate: HomeViewScreenProtocol?
    
    //MARK: - Views
    private lazy var carrousselView: HomeCarrousselView = {
        let carrousselView = HomeCarrousselView(model)
        return carrousselView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .large
        } else {
            activity.style = .gray
        }
        activity.isHidden = true
        return activity
    }()
    
    //MARK: - Init
    init (_ model: HomeModels.HomeViewModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
    }
    
    func updateTableview() {
        activityIndicator.stopAnimating()
        isLoadingNextPage = false
        
        tableView.beginUpdates()
        let indexPaths = (tableView.numberOfRows(inSection: 0) ..< model.tableView.count).map { IndexPath(row: $0, section: 0) }
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
        
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
                   
        activityIndicator.isHidden = !model.hasMore
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ViewCodeProtocol
extension HomeViewScreen: ViewCodeProtocol {
    func setupHierarchy() {
        self.addSubview(activityIndicator)
        self.addSubview(tableView)
        self.addSubview(carrousselView)
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        carrousselView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(carrousselHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(carrousselHeight)
        }
    }
    
    func aditionalSetup() {
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        tableView.reloadData()
        activityIndicator.isHidden = !model.hasMore
    }
}

//MARK: - TableViewDataSource / Delegate
extension HomeViewScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.tableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier) as? HomeTableViewCell
        cell?.setupHero(model.tableView[indexPath.row])
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - HomeViewScreenPersistanceProtocol
extension HomeViewScreen: HomeViewScreenPersistanceProtocol {
    func imageDidLoad(_ image:UIImage, hero: HomeModels.HomeViewModel.Hero) {
        if let i = model.carroussel.firstIndex(where: { $0.id == hero.id }) {
            model.carroussel[i].image = image
            delegate?.saveImage(image, forIndex: i, at: .carroussel)
        }
        if let j = model.tableView.firstIndex(where: { $0.id == hero.id }) {
            model.tableView[j].image = image
            delegate?.saveImage(image, forIndex: j, at: .tableView)
        }
    }

}

//MARK: - ScrollViewDelegate
extension HomeViewScreen: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingNextPage else {
            return
        }
        
        let offset = scrollView.contentOffset
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let reachingPoint = self.frame.size.height - activityIndicator.frame.origin.y
        
        if scrollView.contentOffset.y < 0 {
            let increment = scrollView.contentOffset.y * -1
            carrousselView.snp.updateConstraints { make in
                make.height.equalTo(carrousselHeight + increment)
            }
            return
        } else if carrousselView.frame.size.height > carrousselHeight  {
            carrousselView.snp.updateConstraints { make in
                make.height.equalTo(carrousselHeight)
            }
        }
          
        if offset.y > (contentHeight - frameHeight + reachingPoint) && model.hasMore {
            isLoadingNextPage = true
            
            scrollView.isUserInteractionEnabled = false
            scrollView.isScrollEnabled = false
            scrollView.setContentOffset(offset, animated: false)

            activityIndicator.startAnimating()
            delegate?.requestMoreHeroes()
        }
    }
}

