//
//  DataExtension.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

#if DEBUG
public extension Data {
    
    var stringValue: String? {
        if let  object = try? JSONSerialization.jsonObject(with: self, options: .allowFragments),
            let string = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) {
            return String(data: string, encoding: .utf8)
        }
        return String(data: self, encoding: .utf8)
    }
    
}
#endif
