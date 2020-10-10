//
//  AppDelegate.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let homeController = HomeFactory.makeController()

        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window?.backgroundColor = .white
        window?.rootViewController = homeController
        window?.makeKeyAndVisible()
        
        return true
    }

}

