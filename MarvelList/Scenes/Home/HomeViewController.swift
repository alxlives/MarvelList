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
    
    private var viewScreen: HomeViewScreen!
    private var interactor: (HomeBusinessLogic & HomeDataStoreProtocol)?
    private var router: HomeRouterProtocol?
    private var model: HomeModels.HomeViewModel?
        
    func configureInteractor(_ interactor: (HomeBusinessLogic & HomeDataStoreProtocol)?) {
        self.interactor = interactor
    }
    
    func configureRouter(_ router: HomeRouterProtocol) {
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Marvel Heroes"
        setupView()
        interactor?.getHeroes()
    }
    
//    func setupView() {
//
//        guard let model = self.model else {
//            return
//        }
//
//        activityIndicator.isHidden = true
//
//    }
}

extension HomeViewController: ViewCodeProtocol {
    
    func setupHierarchy() {
    }
    
    func setupConstraints() {
    }
    
    func aditionalSetup() {
        self.view.backgroundColor = .white
    }
    
    func setupViewScreen() {
        view.addSubview(viewScreen)
        viewScreen.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension HomeViewController: HomeDisplayLogic {
    
    func displayHeroes(model: HomeModels.HomeViewModel) {
        self.model = model
        interactor?.homeViewModel = model
        
        DispatchQueue.main.async {
            self.viewScreen = HomeViewScreen(model)
            self.setupViewScreen()
            self.viewScreen.delegate = self
            self.viewScreen.tableView.dataSource = self
            self.viewScreen.tableView.reloadData()
            self.viewScreen.activityIndicator.isHidden = false
        }
    }
    
    func displayNextPage(model: HomeModels.HomeViewModel) {
        self.model = model
        self.viewScreen.model = model
        DispatchQueue.main.async {
            self.viewScreen.activityIndicator.stopAnimating()
            self.viewScreen.isLoadingNextPage = false
            self.viewScreen.tableView.beginUpdates()
            
            let indexPaths = (self.viewScreen.tableView.numberOfRows(inSection: 0) ..< model.tableView.count).map { IndexPath(row: $0, section: 0) }

            self.viewScreen.tableView.insertRows(at: indexPaths, with: .automatic)
            self.viewScreen.tableView.endUpdates()
            self.viewScreen.tableView.isUserInteractionEnabled = true
            self.viewScreen.tableView.isScrollEnabled = true
            
            self.viewScreen.activityIndicator.isHidden = !model.hasMore
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
        
        let cell = viewScreen.tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell

        cell?.setupHero(viewModel[indexPath.row])
        cell?.delegate = self
        return cell ?? UITableViewCell()
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

extension HomeViewController: HomeViewScreenProtocol {
    func requestMoreHeroes() {
        self.interactor?.getHeroes()
    }
}
