//
//  HomeInteractorTest.swift
//  MarvelListTests
//
//  Created by MacDev on 11/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import XCTest
import CoreData

class HomeInteractorTest: XCTestCase {
    
    var interactor: HomeInteractor?
    var presenter = HomePresenterMock()
    var worker = HomeWorkerMock()
    
    override func setUp() {
        super.setUp()
        interactor = HomeInteractor(presenter: presenter, worker: worker)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFirstCall() {
        worker.success = true
        interactor?.getHeroes()
        XCTAssert(presenter.didPresentLoader)
        XCTAssert(presenter.didPresentSuccess)
    }
    
    func testError() {
        worker.success = false
        interactor?.getHeroes()
        XCTAssert(presenter.didPresentError)
    }
    
    func testLocalStorage() {
        
        let viewModel = HomeViewControllerMock().getMockViewModel()

        interactor?.homeViewModel = viewModel
        interactor?.dataStorage.context = contextForTests()
        interactor?.total = viewModel.carroussel.count + viewModel.tableView.count
        interactor?.saveDataToLocalStorage()
        
        interactor?.homeViewModel = nil
        interactor?.getHeroes()
        XCTAssert(presenter.didPresentLocalStorage)
    }
    
    func contextForTests() -> NSManagedObjectContext {
        let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)!
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
}
