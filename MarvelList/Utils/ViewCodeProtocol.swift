//
//  ViewCodeProtocol.swift
//  MarvelList
//
//  Created by MacDev on 09/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import Foundation

public protocol ViewCodeProtocol {
    func setupView()
    func setupHierarchy()
    func setupConstraints()
    func aditionalSetup()
}

public extension ViewCodeProtocol {
    func setupView() {
        setupHierarchy()
        setupConstraints()
        aditionalSetup()
    }
    
    func aditionalSetup() { }
}
