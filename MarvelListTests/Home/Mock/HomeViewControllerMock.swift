//
//  HomeViewControllerMock.swift
//  MarvelListTests
//
//  Created by MacDev on 11/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import XCTest

class HomeViewControllerMock {
    var didDisplayLoader = false
    var didDisplayHeroes = false
    var didDisplayNextPage = false
    var didDisplayError = false
    
    var model: HomeModels.HomeViewModel?
}

extension HomeViewControllerMock: HomeDisplayLogic {
    
    func displayLoader() {
        didDisplayLoader = true
    }
    
    func displayHeroes(model: HomeModels.HomeViewModel) {
        self.model = model
        didDisplayHeroes = true
    }
    
    func displayNextPage(model: HomeModels.HomeViewModel) {
        self.model = model
        didDisplayNextPage = true
    }
    
    func displayError(error: NetworkError) {
        didDisplayError = true
    }
    
    func getMockViewModel() -> HomeModels.HomeViewModel {
        let mockHero = HomeWorkerMock().mockHero
        let mockData = HomeModels.HomeResponse.Data(limit: 6, total: 6, count: 6, offset: 0, results: [mockHero, mockHero, mockHero, mockHero, mockHero, mockHero])
        let mockResponse = HomeModels.HomeResponse(data: mockData)
        
        let heroes: [HomeModels.HomeViewModel.Hero] = mockResponse.data.results.map {
            return HomeModels.HomeViewModel.Hero(id: String($0.id),
                                                  name: $0.name,
                                                  description: $0.description,
                                                  thumbUrl: $0.thumbnail.path + "." + $0.thumbnail.extension, image: nil)
        }
        
        let carrousselHeroes = Array(heroes.prefix(5))
        let tableViewHeroes = Array(heroes.dropFirst(5))
        return HomeModels.HomeViewModel(carroussel: carrousselHeroes, tableView: tableViewHeroes, hasMore: false)
    }
}
