//
//  HomeInteractor.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

protocol HomeBusinessLogic {
    
}

class HomeInteractor: HomeBusinessLogic {
    
    private var presenter: HomePresentationLogic
    private var worker: HomeWorkerProtocol

    init(presenter: HomePresentationLogic, worker: HomeWorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }
}
