//
//  RequestError.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

public enum RequestError: LocalizedError {
    case encodingFailed
    case decodingFailed(message: String)
    case invalidRequest(message: String)
    case noResponse
    case serverError(code: Int, data: Data?)
}
