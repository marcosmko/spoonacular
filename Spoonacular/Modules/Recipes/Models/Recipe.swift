//
//  Recipe.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

class Recipe: Decodable {
    var id: Int = -1
    var title: String = ""
    var summary: String?
    var image: URL?
}
