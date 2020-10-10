//
//  NetworkRequest.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    var url: String { get }
    var method: HttpMethod { get }
}

enum HttpMethod: String {
    case get
    
    var value: String {
        self.rawValue.uppercased()
    }
}
