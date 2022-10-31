//
//  ServerError.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

enum ServerExceptionType: String, Decodable {
    case genericServerException
    
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .genericServerException
    }
}

public struct ServerError: CustomError, Decodable {
    let exceptionType: ServerExceptionType
    let displayMessage: String?
    
    public var errorDescription: String? {
        switch self.exceptionType {
        default:
            return self.displayMessage ?? "alert_generic_message".localized
        }
    }
}
