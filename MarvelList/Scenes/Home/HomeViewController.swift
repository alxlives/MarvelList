//
//  HomeViewController.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

protocol HomeDisplayLogic: class {
    func displayHeroes(model: HomeModels.HomeViewModel)
    func displayError(error: NetworkError)
}

class HomeViewController: UIViewController {
    
    private var interactor: HomeBusinessLogic?
    private var router: HomeRouterProtocol?
    private var model: HomeModels.HomeViewModel?
    
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
}

extension HomeViewController: HomeDisplayLogic {
    
    func displayHeroes(model: HomeModels.HomeViewModel) {
        self.model = model
        print(model.Heroes)
    }
    
    func displayError(error: NetworkError) {
        print(error.localizedDescription)
    }

}
