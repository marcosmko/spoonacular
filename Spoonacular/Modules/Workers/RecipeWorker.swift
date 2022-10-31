//
//  RecipeWorker.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

class RecipeWorker {
    private let recipesApi: RecipesApiProtocol.Type
    
    init(recipesApi: RecipesApiProtocol.Type) {
        self.recipesApi = recipesApi
    }
    
    func getRecipes(query: String) throws -> [Recipe] {
        if query.isEmpty {
            return try self.recipesApi.getRandomRecipes()
        } else {
            return try self.recipesApi.getComplexSearch(query: query)
        }
    }
    
    func getRecipe(id: Int) throws -> Recipe {
        return try self.recipesApi.getRecipe(id: id)
    }
}
