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
    var total: Int { get set }
    var homeViewModel: HomeModels.HomeViewModel? { get set }
    func setImage(_ image:UIImage, forIndex: Int, at: HomeModels.HomePersistance)
    func saveDataToLocalStorage()
}

class HomeInteractor: HomeBusinessLogic, HomeDataStoreProtocol {
    //MARK: - Properties
    private var presenter: HomePresentationLogic
    private var worker: HomeWorkerProtocol

    //MARK: - DataStore
    var currentOffset: Int = 0
    var total: Int = 0
    var homeViewModel: HomeModels.HomeViewModel?
    
    //MARK: - Init
    init(presenter: HomePresentationLogic, worker: HomeWorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }
    
    //MARK: - Functions
    func getHeroes() {
        if homeViewModel == nil {
            presenter.presentLoader()
            //MARK: - Core Data
            if let heroesList = MarvelListDataStorage().retreiveHeroes() {
                if heroesList.count > 0 {
                    currentOffset = heroesList.count
                    presenter.presentLocalStorage(heroes: heroesList, hasMore: MarvelListDataStorage().hasMore())
                    return
                }
            }
        }
        
        let request = HomeRequest(offset: currentOffset)
        worker.getHeroes(request: request, onSuccess: { result in
            self.currentOffset = result.data.offset + result.data.count
            self.total = result.data.total
            self.presenter.presentSuccess(result, viewModel: self.homeViewModel)
        }, onFailure: { error in
            self.presenter.presentError(error)
        })
    }
    
    func setImage(_ image:UIImage, forIndex: Int, at: HomeModels.HomePersistance) {
        switch at {
        case .carroussel:
            homeViewModel?.carroussel[forIndex].image = image
        case .tableView:
            homeViewModel?.tableView[forIndex].image = image
        }
    }
    
    func saveDataToLocalStorage() {
        guard let model = homeViewModel else {
            return
        }
        var heroesArray: [HomeModels.HomeViewModel.Hero] = []
        heroesArray.append(contentsOf: model.carroussel)
        heroesArray.append(contentsOf: model.tableView)
        let hasMore: Bool = self.currentOffset < self.total
        MarvelListDataStorage().save(heroes: heroesArray, hasMore: hasMore)
    }
    
}
