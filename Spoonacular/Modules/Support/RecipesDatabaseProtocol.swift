//
//  RecipesDatabaseProtocol.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

protocol RecipesDatabaseProtocol {
    static func fetchAll() throws -> [Recipe]
    static func save(_ object: Recipe) throws
    static func delete(_ object: Recipe) throws
}
