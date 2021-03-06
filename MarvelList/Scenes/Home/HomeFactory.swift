
//
//  HomeFactory.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

struct HomeFactory {
    static func makeController() -> UIViewController {
        let viewController = HomeViewController()
        let presenter = HomePresenter(viewController: viewController)
        let worker = HomeWorker()
        let interactor = HomeInteractor(presenter: presenter, worker: worker)
        viewController.configureInteractor(interactor)
        let router = HomeRouter()
        viewController.configureRouter(router)
        
        return  viewController
    }
}
