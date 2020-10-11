//
//  HomeViewController.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit
import SnapKit

protocol HomeDisplayLogic: class {
    func displayLoader()
    func displayHeroes(model: HomeModels.HomeViewModel)
    func displayNextPage(model: HomeModels.HomeViewModel)
    func displayError(error: NetworkError)
}

class HomeViewController: UIViewController {
    //MARK: - Properties
    private var viewScreen: HomeViewScreen!
    private var interactor: (HomeBusinessLogic & HomeDataStoreProtocol)?
    private var router: HomeRouterProtocol?
    private var model: HomeModels.HomeViewModel?
    
    //MARK: - Factory Configuration
    func configureInteractor(_ interactor: (HomeBusinessLogic & HomeDataStoreProtocol)?) {
        self.interactor = interactor
    }
    
    func configureRouter(_ router: HomeRouterProtocol) {
        self.router = router
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Marvel Heroes"
        setupView()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        interactor?.saveDataToLocalStorage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.model == nil {
            interactor?.getHeroes()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension HomeViewController: ViewCodeProtocol {
    func setupHierarchy() { }
    
    func setupConstraints() { }
    
    func aditionalSetup() {
        self.view.backgroundColor = Constants.Color.backgroundColor
    }
    
    func setupViewScreen() {
        view.addSubview(viewScreen)
        viewScreen.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HomeViewController: HomeDisplayLogic {
    func displayLoader() {
        CustomLoader.open()
    }
    
    func displayHeroes(model: HomeModels.HomeViewModel) {
        self.model = model
        interactor?.homeViewModel = model
        DispatchQueue.main.async {
            CustomLoader.close()
            self.viewScreen = HomeViewScreen(model)
            self.setupViewScreen()
            self.viewScreen.delegate = self
        }
    }
    
    func displayNextPage(model: HomeModels.HomeViewModel) {
        self.model = model
        self.viewScreen.model = model
        interactor?.homeViewModel = model
        DispatchQueue.main.async {
            self.viewScreen.updateTableview()
        }
    }
    
    func displayError(error: NetworkError) {
        let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { action in
            self.interactor?.getHeroes()
        })
        alert.addAction(action)
        
        DispatchQueue.main.async {
            CustomLoader.close()
            self.present(alert, animated: true)
        }
    }
}

extension HomeViewController: HomeViewScreenProtocol {
    func saveImage(_ image:UIImage, forIndex index: Int, at: HomeModels.HomePersistance) {
        interactor?.setImage(image, forIndex: index, at: at)
    }
    
    func requestMoreHeroes() {
        self.interactor?.getHeroes()
    }
}
