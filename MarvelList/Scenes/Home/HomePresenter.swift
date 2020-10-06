//
//  HomePresenter.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

protocol HomePresentationLogic {
    
}

class HomePresenter {
    private weak var viewController: HomeDisplayLogic?
    
    init(viewController: HomeDisplayLogic) {
        self.viewController = viewController
    }
}

extension HomePresenter: HomePresentationLogic {
    
}
