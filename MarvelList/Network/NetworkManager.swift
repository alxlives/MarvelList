//
//  NetworkManage.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import Foundation

class NetworkManager {
    
    class func request<Res: Decodable>(_ networkRequest: NetworkRequest,
                                       completion: @escaping (Result<Res, NetworkError>) -> Void) {
        
        guard let url = URL(string: networkRequest.url) else {
            NetworkLog.error(NetworkError.invalidURL)
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = networkRequest.method.value

        NetworkLog.request(request)

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                var networkError: NetworkError = .unknowError
                if error!.localizedDescription.uppercased().contains("OFFLINE") {
                    networkError = .offline
                }
                NetworkLog.error(networkError)
                completion(.failure(networkError))
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                NetworkLog.error(NetworkError.invalidResponseType)
                completion(.failure(.invalidResponseType))
                return
            }
            
            guard
                let data = data,
                let object: Res = self.decode(data: data) else {
                    NetworkLog.error(NetworkError.objectNotDecoded)
                    completion(.failure(.objectNotDecoded))
                    return
            }
            
            NetworkLog.response(response, data: data)
            completion(.success(object))
        }.resume()
    }
    
    class func decode<T: Decodable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(T.self, from: data) else { return nil }
        return object
    }
}
