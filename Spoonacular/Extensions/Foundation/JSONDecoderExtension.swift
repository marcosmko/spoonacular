//
//  JSONDecoderExtension.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

extension JSONDecoder {
    static var `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601GMT
        return decoder
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static var iso8601GMT: JSONDecoder.DateDecodingStrategy {
        return .formatted(ISO8601DateFormatter())
    }
}
