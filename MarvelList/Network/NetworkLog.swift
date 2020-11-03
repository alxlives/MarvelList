//
//  NetworkLog.swift
//  MarvelList
//
//  Created by MacDev on 03/11/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import Foundation

class NetworkLog {
    
    static func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
    
    static func request(_ request: URLRequest) {
        divider()

        if let url = request.url?.absoluteString {
            log("📤 Request: \(request.httpMethod!) \(url)")
        }

        if let headers = request.allHTTPHeaderFields {
            dictionary(headers, title: "headers")
        }

        if let httpBody = request.httpBody {
            do {
                let json = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)
                let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

                if let string = NSString(data: pretty, encoding: String.Encoding.utf8.rawValue) {
                    log("JSON: \(string)")
                }
            } catch {
                if let string = NSString(data: httpBody, encoding: String.Encoding.utf8.rawValue) {
                    log("Data: \(string)")
                }
            }
        }
    }
    
    static func response(_ response: URLResponse?, data: Data? = nil) {
        divider()
        
        guard let response = response else {
            log("⚠️ response: nil")
            return
        }
        
        if let url = response.url?.absoluteString {
            log("📥 response: \(url)")
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            let localizedStatus = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode).capitalized
            log("status: \(httpResponse.statusCode) - \(localizedStatus)")
            dictionary(httpResponse.allHeaderFields, title: "headers")
        }
        
        guard let data = data else { return }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            if let string = NSString(data: pretty, encoding: String.Encoding.utf8.rawValue) {
                log("JSON: \(string)")
            }
        } catch {
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                log("Data: \(string)")
            }
        }
        
    }
    
    static func error(_ error: Error?) {
        divider()
        guard let error = error else {
            log("⁉️ Error: nil")
            return
        }
        log("❗️ Error: \(error.localizedDescription)")
    }
    
    private static func divider() {
        log("======================")
    }
    
    private static func dictionary(_ dict: [AnyHashable: Any], title: String = "") {
        log(title + ": [")
        for (key, value) in dict {
            log(" \(key) : \(value)")
        }
        log("]")
    }
    
}
