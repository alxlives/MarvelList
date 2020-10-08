//
//  HomeWorker.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import Foundation

typealias HomeResponse = ((_ response: HomeModels.HomeResponse) -> Void)
typealias HomeError = ((_ error: NetworkError) -> Void)

protocol HomeWorkerProtocol {
    func getHeroes(request: HomeRequest, onSuccess: @escaping HomeResponse, onFailure: @escaping HomeError)
}

class HomeWorker: HomeWorkerProtocol {
    
    func getHeroes(request: HomeRequest, onSuccess: @escaping HomeResponse, onFailure: @escaping HomeError) {
                         
         NetworkManager.request(request, completion: { (result: Result<HomeModels.HomeResponse, NetworkError>) in
            
            switch result {
            case .success(let response):
                onSuccess(response)
            case .failure(let error):
                onFailure(error)
            }
         })
    }
    
}
