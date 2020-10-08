//
//  HomeInteractor.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit
protocol HomeBusinessLogic {
    func getHeroes()
}

protocol HomeDataStoreProtocol {
    var currentOffset: Int { get set }
    var homeViewModel: HomeModels.HomeViewModel? { get set }
    func setImage(_ image:UIImage, forIndex: Int)
}

class HomeInteractor: HomeBusinessLogic, HomeDataStoreProtocol {
    
    private var presenter: HomePresentationLogic
    private var worker: HomeWorkerProtocol

    var currentOffset: Int = 0
    var homeViewModel: HomeModels.HomeViewModel?
    
    init(presenter: HomePresentationLogic, worker: HomeWorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func getHeroes() {

        let request = HomeRequest(offset: currentOffset)
        worker.getHeroes(request: request, onSuccess: { result in
            self.currentOffset = result.data.offset + result.data.count
            
            print(result.data.total)
            self.presenter.presentSuccess(result, viewModel: self.homeViewModel)
        }, onFailure: { error in
            self.presenter.presentError(error)
        })
        
    }
    
    func setImage(_ image:UIImage, forIndex: Int) {
        homeViewModel?.tableView[forIndex].image = image
    }
    
}
