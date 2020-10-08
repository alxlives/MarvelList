//
//  HomeViewController.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit
import SnapKit

protocol HomeDisplayLogic: class {
    func displayHeroes(model: HomeModels.HomeViewModel)
    func displayNextPage(model: HomeModels.HomeViewModel)
    func displayError(error: NetworkError)
}

class HomeViewController: UIViewController {
    
    private var interactor: (HomeBusinessLogic & HomeDataStoreProtocol)?
    private var router: HomeRouterProtocol?
    private var model: HomeModels.HomeViewModel?
    
    @IBOutlet weak var carrousselHolder: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoadingNextPage = false
    
    func configureInteractor(_ interactor: (HomeBusinessLogic & HomeDataStoreProtocol)?) {
        self.interactor = interactor
    }
    
    func configureRouter(_ router: HomeRouterProtocol) {
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Marvel Heroes"
        interactor?.getHeroes()
    }
    
    func setupView() {
        
        guard let model = self.model else {
            return
        }
        
        let carrousselView = HomeCarrousselView.instanceFromNib()
        carrousselView.translatesAutoresizingMaskIntoConstraints = false
        
        carrousselHolder.addSubview(carrousselView)
        
        carrousselView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        carrousselView.model = model
        
        activityIndicator.isHidden = true

    }
}

extension HomeViewController: HomeDisplayLogic {
    
    func displayHeroes(model: HomeModels.HomeViewModel) {
        self.model = model
        interactor?.homeViewModel = model
        DispatchQueue.main.async {
            self.setupView()
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.contentInsetAdjustmentBehavior = .never
            self.tableView.reloadData()
            
            self.activityIndicator.isHidden = false
        }
    }
    
    func displayNextPage(model: HomeModels.HomeViewModel) {
        self.model = model
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.isLoadingNextPage = false
            self.tableView.beginUpdates()
            
            let indexPaths = (self.tableView.numberOfRows(inSection: 0) ..< model.tableView.count).map { IndexPath(row: $0, section: 0) }

            self.tableView.insertRows(at: indexPaths, with: .automatic)
            self.tableView.endUpdates()
            self.tableView.isUserInteractionEnabled = true
            self.tableView.isScrollEnabled = true
            
            self.activityIndicator.isHidden = !model.hasMore
        }
        
        interactor?.homeViewModel = self.model

    }

    
    func displayError(error: NetworkError) {
        
        let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { action in
                self.interactor?.getHeroes()
            })
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.tableView.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let viewModel = model?.tableView else {
            return UITableViewCell()
        }
        
        let cell = HomeTableViewCell.instanceFromNib()
        cell.setupHero(viewModel[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeViewController: HomeTableViewCellProtocol {
    
    func imageDidLoad(_ image: UIImage, hero: HomeModels.HomeViewModel.Hero) {
        
        if let i = self.model?.tableView.firstIndex(where: { $0.id == hero.id }) {
            self.model?.tableView[i].image = image
            interactor?.setImage(image, forIndex: i)
        }
        
    }
    
    
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !isLoadingNextPage, let viewModel = self.model else {
            return
        }
        
        let offset = scrollView.contentOffset
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let reachingPoint = self.view.frame.size.height - activityIndicator.frame.origin.y
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
            return
        }
                
        if offset.y > (contentHeight - frameHeight + reachingPoint) && viewModel.hasMore {
            isLoadingNextPage = true
            
            scrollView.isUserInteractionEnabled = false
            scrollView.isScrollEnabled = false
            scrollView.setContentOffset(offset, animated: false)

            activityIndicator.startAnimating()
            
            self.interactor?.getHeroes()
        }
        
    }
}
