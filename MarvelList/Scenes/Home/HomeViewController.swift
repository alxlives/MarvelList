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
    func displayError(error: NetworkError)
}

class HomeViewController: UIViewController {
    
    private var interactor: HomeBusinessLogic?
    private var router: HomeRouterProtocol?
    private var model: HomeModels.HomeViewModel?
    
    @IBOutlet weak var carrousselHolder: UIView!
    @IBOutlet weak var tableView: UITableView!
        
    func configureInteractor(_ interactor: HomeBusinessLogic) {
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
        carrousselHolder.addSubview(carrousselView)
        
        carrousselView.snp.makeConstraints{ make in
            make.margins.equalToSuperview()
        }
        
        carrousselView.model = model

    }
}

extension HomeViewController: HomeDisplayLogic {
    
    func displayHeroes(model: HomeModels.HomeViewModel) {
        self.model = model
        DispatchQueue.main.async {
            self.setupView()
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
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
        return model?.TableView.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let viewModel = model?.TableView else {
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
        
        if let i = self.model?.TableView.firstIndex(where: { $0.id == hero.id }) {
            self.model?.TableView[i].image = image
        }
        
    }
    
    
}
