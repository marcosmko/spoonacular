//
//  RecipesApiProtocol.swift
//  McDonalds
//
//  Created by Marcos Kobuchi on 25/10/22.
//

import Foundation

protocol RecipesApiProtocol {
    static func getRandomRecipes() throws -> [Recipe]
    static func getComplexSearch(query: String) throws -> [Recipe]
    static func getRecipe(id: Int) throws -> Recipe
}
