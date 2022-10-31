//
//  AttributedStringExtension.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import SwiftUI

extension AttributedString {
    func with(font: Font) -> AttributedString {
        var new = self
        new.font = font
        return new
    }
}
