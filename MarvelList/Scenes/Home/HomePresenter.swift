//
//  HomePresenter.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

protocol HomePresentationLogic {
    func presentSuccess(_ response: HomeModels.HomeResponse)
    func presentError(_ error: NetworkError)
}

class HomePresenter {
    private weak var viewController: HomeDisplayLogic?
    
    init(viewController: HomeDisplayLogic) {
        self.viewController = viewController
    }
}

extension HomePresenter: HomePresentationLogic {
    
    func presentSuccess(_ response: HomeModels.HomeResponse) {
        
        let heroes: [HomeModels.HomeViewModel.Heroe] = response.data.results.map {
            return HomeModels.HomeViewModel.Heroe(id: String($0.id),
                                                  name: $0.name,
                                                  description: $0.description,
                                                  thumb: $0.thumbnail.path + "." + $0.thumbnail.extension)
        }
        
        let carrousselHeroes = Array(heroes.prefix(5))
        let tableViewHeroes = Array(heroes.dropFirst(5))
        let viewModel = HomeModels.HomeViewModel(Carroussel: carrousselHeroes, TableView: tableViewHeroes)
        
        viewController?.displayHeroes(model: viewModel)
        
    }
    
    func presentError(_ error: NetworkError) {
        viewController?.displayError(error: error)
    }
    
    
}
