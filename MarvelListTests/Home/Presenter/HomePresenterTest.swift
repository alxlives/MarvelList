//
//  HomePresenterTest.swift
//  MarvelListTests
//
//  Created by MacDev on 11/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import XCTest

class HomePresenterTest: XCTestCase {
    
    var controller = HomeViewControllerMock()
    var presenter: HomePresenter?
    
    override func setUp() {
        super.setUp()
        presenter = HomePresenter(viewController: controller)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccess() {
        let mockHero = HomeWorkerMock().mockHero
        let mockData = HomeModels.HomeResponse.Data(limit: 6, total: 6, count: 6, offset: 0, results: [mockHero, mockHero, mockHero, mockHero, mockHero, mockHero])
        let mockResponse = HomeModels.HomeResponse(data: mockData)
        
        presenter?.presentSuccess(mockResponse, viewModel: nil)
        
        XCTAssert(controller.didDisplayHeroes)
        XCTAssert(controller.model?.carroussel.count == 5)
        XCTAssert(controller.model?.tableView.count == 1)

        guard let model = controller.model else {
            return
        }
        
        presenter?.presentSuccess(mockResponse, viewModel: model)
        XCTAssert(controller.didDisplayNextPage)
    }
    
    func testFailure() {
        
        presenter?.presentError(NetworkError.unknowError)
        XCTAssert(controller.didDisplayError)

    }
}
