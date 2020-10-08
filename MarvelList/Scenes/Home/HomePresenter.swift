//
//  HomePresenter.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

protocol HomePresentationLogic {
    func presentSuccess(_ response: HomeModels.HomeResponse, viewModel:HomeModels.HomeViewModel?)
    func presentError(_ error: NetworkError)
}

class HomePresenter {
    private weak var viewController: HomeDisplayLogic?
    
    init(viewController: HomeDisplayLogic) {
        self.viewController = viewController
    }
}

extension HomePresenter: HomePresentationLogic {
    
    func presentSuccess(_ response: HomeModels.HomeResponse, viewModel:HomeModels.HomeViewModel?) {
                
        let hasMore: Bool = response.data.offset + response.data.count < response.data.total

        let heroes: [HomeModels.HomeViewModel.Hero] = response.data.results.map {
            return HomeModels.HomeViewModel.Hero(id: String($0.id),
                                                  name: $0.name,
                                                  description: $0.description,
                                                  thumbUrl: $0.thumbnail.path + "." + $0.thumbnail.extension, image: nil)
        }
        
        guard var model = viewModel else {
            let carrousselHeroes = Array(heroes.prefix(5))
            let tableViewHeroes = Array(heroes.dropFirst(5))
            let viewModel = HomeModels.HomeViewModel(carroussel: carrousselHeroes, tableView: tableViewHeroes, hasMore: hasMore)
                   
            viewController?.displayHeroes(model: viewModel)
            return
        }
        
        model.tableView.append(contentsOf: heroes)
        model.hasMore = hasMore
        viewController?.displayNextPage(model: model)
    }
    
    func presentError(_ error: NetworkError) {
        viewController?.displayError(error: error)
    }
    
    
}
