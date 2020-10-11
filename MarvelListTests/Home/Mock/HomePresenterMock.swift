//
//  HomePresenterMock.swift
//  MarvelListTests
//
//  Created by MacDev on 11/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import XCTest

class HomePresenterMock {
    var didPresentLoader = false
    var didPresentLocalStorage = false
    var didPresentSuccess = false
    var didPresentError = false
}

extension HomePresenterMock: HomePresentationLogic {
    
    func presentLoader() {
        didPresentLoader = true
    }
    
    func presentLocalStorage(heroes: [HomeModels.HomeViewModel.Hero], hasMore: Bool) {
        didPresentLocalStorage = true
    }
    
    func presentSuccess(_ response: HomeModels.HomeResponse, viewModel:HomeModels.HomeViewModel?) {
        didPresentSuccess = true
    }
    
    func presentError(_ error: NetworkError) {
        didPresentError = true
    }
}
