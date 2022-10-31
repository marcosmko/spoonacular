//
//  Ref.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 30/10/22.
//

import Foundation

class Ref<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}
