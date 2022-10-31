//
//  Recipe.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

struct Recipe: Decodable {
    let id: Int
    let title: String
    let summary: String?
    let image: URL?
}
