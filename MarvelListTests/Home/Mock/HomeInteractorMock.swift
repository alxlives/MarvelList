//
//  HomeInteractorMock.swift
//  MarvelListTests
//
//  Created by MacDev on 11/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import XCTest

class HomeInteractorMock {
    var getHeroesCalled = false
    var saveToLocalStorageCalled = false
    var setImageCalled = false

    var currentOffset: Int = 0
    var total: Int = 0
    var homeViewModel: HomeModels.HomeViewModel?
}

extension HomeInteractorMock: HomeBusinessLogic {
    
    func getHeroes() {
        getHeroesCalled = true
    }
    
}

extension HomeInteractorMock: HomeDataStoreProtocol {
    
    func setImage(_ image: UIImage, forIndex: Int, at: HomeModels.HomePersistance) {
        setImageCalled = true
    }
    
    func saveDataToLocalStorage() {
        saveToLocalStorageCalled = true
    }
    
}
