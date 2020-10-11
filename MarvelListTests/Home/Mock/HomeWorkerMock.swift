//
//  HomeWorkerMock.swift
//  MarvelListTests
//
//  Created by MacDev on 11/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import XCTest

class HomeWorkerMock {
    var success = false
    
    let mockHero = HomeModels.HomeResponse.Results(id: 1, name: "test", description: "desc", thumbnail: HomeModels.HomeResponse.Thumbnail(path: "https://www.google.com.br/images/branding/googlelogo/2x/googlelogo_color_272x92dp", extension: "png"))
}

extension HomeWorkerMock: HomeWorkerProtocol {
    
    func getHeroes(request: HomeRequest, onSuccess: @escaping HomeResponse, onFailure: @escaping HomeError) {
        
        let mockData = HomeModels.HomeResponse.Data(limit: 1, total: 1, count: 1, offset: 1, results: [mockHero])
        let response = HomeModels.HomeResponse(data: mockData)
        
        if success {
            onSuccess(response)
            return
        }
        
        let error = NetworkError.unknowError
        onFailure(error)
    }
    
    
}
