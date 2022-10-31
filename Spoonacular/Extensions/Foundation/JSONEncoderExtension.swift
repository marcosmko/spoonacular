//
//  JSONEncoderExtension.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

extension JSONEncoder {
    static var `default`: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601GMT
        return encoder
    }()
}

extension JSONEncoder.DateEncodingStrategy {
    static var iso8601GMT: JSONEncoder.DateEncodingStrategy {
        return .formatted(ISO8601DateFormatter())
    }
}
