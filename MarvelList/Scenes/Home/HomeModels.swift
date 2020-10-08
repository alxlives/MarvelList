//
//  HomeModels.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

struct HomeModels {
    
    struct HomeViewModel {
        let carroussel: [Hero]
        var tableView: [Hero]
        var hasMore: Bool
        
        struct Hero {
            let id: String
            let name: String
            let description: String
            let thumbUrl: String?
            var image: UIImage?
        }
    }
    
    struct HomeResponse: Decodable {
        let data: Data
        
        struct Data: Decodable {
            let limit: Int
            let total: Int
            let count: Int
            let offset: Int
            let results: [Results]
        }
        
        struct Results: Decodable {
            let id: Int
            let name: String
            let description: String
            let thumbnail: Thumbnail
        }
        
        struct Thumbnail: Decodable {
            let path: String
            let `extension`: String
        }
    }
}

class HomeRequest: NetworkRequest {
    var url: String
    var baseURL = "https://gateway.marvel.com/v1/public/characters"
    var publicKey = "d45326ff4b90a16ccedce23966fa08db"
    var privateKey = "95eb75a248dce98a06fef346e235ab9aa1721d32"
    
    init (offset:Int) {
        let offset = String(offset)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"
        let ts = formatter.string(from: Date())
        let hash = NetworkEncription.MD5(ts+privateKey+publicKey) ?? ""
        let url = baseURL + "?ts=" + ts + "&apikey=" + publicKey + "&hash=" + hash + "&offset=" + offset
        
        print(url)

        self.url = url
    }
    
    var method: HttpMethod = {
        return .get
    }()
    
}
