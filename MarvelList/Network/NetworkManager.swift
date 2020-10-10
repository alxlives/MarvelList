//
//  NetworkManage.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import Foundation

class NetworkManager {
    class func request<Res: Decodable>(_ request: NetworkRequest,
                              completion: @escaping (Result<Res, NetworkError>) -> Void) {

        guard let url = URL(string: request.url) else {
              completion(.failure(.invalidURL))
              return
          }
        
        var req = URLRequest(url: url)
        req.httpMethod = request.method.value
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            
            guard error == nil else {
                var networkError: NetworkError = .unknowError
                if error!.localizedDescription.uppercased().contains("OFFLINE") {
                    networkError = .offline
                }
                    completion(.failure(networkError))
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                    completion(.failure(.invalidResponseType))
                return
            }
            
            guard
                let data = data,
                let object: Res = self.decode(data: data) else {
                    completion(.failure(.objectNotDecoded))
                return
            }
            
            completion(.success(object))
        }.resume()
    }
    
    class func decode<T: Decodable>(data: Data) -> T? {
          let decoder = JSONDecoder()
          
          guard let object = try? decoder.decode(T.self, from: data) else { return nil }
          
          return object
      }
}
