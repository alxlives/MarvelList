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
        var carroussel: [Hero]
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
    
    enum HomePersistance {
        case carroussel
        case tableView
    }
}

class HomeRequest: NetworkRequest {
    internal var url: String
    
    init (offset:Int) {
        let offset = String(offset)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"
        let ts = formatter.string(from: Date())
        let api = Constants.API.self
        let hash = NetworkEncription.MD5(ts+api.privateKey+api.publicKey) ?? ""
        let url = api.baseURL + "?ts=" + ts + "&apikey=" + api.publicKey + "&hash=" + hash + "&offset=" + offset
        self.url = url
    }
    
    var method: HttpMethod = {
        return .get
    }()
    
}
