//
//  HomeViewController.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

protocol HomeDisplayLogic: class {

}

class HomeViewController: UIViewController {
    
    private var interactor: HomeBusinessLogic?
    private var router: HomeRouterProtocol?
    
    func configureInteractor(_ interactor: HomeBusinessLogic) {
        self.interactor = interactor
    }
    
    func configureRouter(_ router: HomeRouterProtocol) {
        self.router = router
    }
}

extension HomeViewController: HomeDisplayLogic {
    
}
