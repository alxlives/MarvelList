//
//  NetworkError.swift
//  MarvelList
//
//  Created by MacDev on 06/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL,
         unknowError,
         offline,
         invalidResponseType,
         objectNotDecoded
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL inválida"
        case .offline: return "Dispositivo offline."
        case .unknowError: return "Erro de conexão desconhecido."
        case .invalidResponseType: return "Tipo de dados retornado é inválido."
        case .objectNotDecoded: return "O objeto retornado não pôde ser decodificado."
        }
    }
}
