//
//  Constants.swift
//  MarvelList
//
//  Created by MacDev on 11/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

enum Constants {
    enum API {
        static let baseURL = "https://gateway.marvel.com/v1/public/characters"
        static let publicKey = "d45326ff4b90a16ccedce23966fa08db"
        static let privateKey = "95eb75a248dce98a06fef346e235ab9aa1721d32"
    }
    enum Carroussel {
        static let height:CGFloat = 200.0
        static let time = 3.0
    }
}
