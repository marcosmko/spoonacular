//
//  Operators.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

infix operator ?=

public func ?= <T>(left: inout T, right: T?) {
    left = right ?? left
}

public func ?= <T>(left: inout T?, right: T?) {
    left = right ?? left
}
