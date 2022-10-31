//
//  Ref.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

class Ref<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}
