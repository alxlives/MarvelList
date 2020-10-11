//
//  HomeViewControllerTest.swift
//  MarvelListTests
//
//  Created by MacDev on 11/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import XCTest

class HomeViewControllerTest: XCTestCase {
    
    var controller: HomeViewController?
    var interactor = HomeInteractorMock()
    
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        controller = HomeViewController()
        controller?.configureInteractor(interactor)
        
        window = UIWindow()
        _ = controller?.view
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testHeroesCall() {
        controller?.viewDidLoad()
        controller?.viewDidAppear(true)
        
        XCTAssert(interactor.getHeroesCalled)
    }
    
    func testScreen() {
        let viewModel = HomeViewControllerMock().getMockViewModel()
        controller?.displayHeroes(model: viewModel)
        
        guard let view = controller?.view as? HomeViewScreen else {
            return
        }
        
        XCTAssertNotNil(view)
    }
    
    func testSaveImage() {
        controller?.saveImage(UIImage(), forIndex: 0, at: .carroussel)
        XCTAssert(interactor.setImageCalled)
    }
    
    func testRequestMoreHeroes() {
        controller?.requestMoreHeroes()
        XCTAssert(interactor.getHeroesCalled)
    }
    
    func testSaveLocalStorage() {
        controller?.appMovedToBackground()
        XCTAssert(interactor.saveToLocalStorageCalled)
    }
    
}
    
