//
//  RecipeWorker.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

class RecipeWorker {
    private let recipesApi: RecipesApiProtocol.Type
    private let recipesDatabase: RecipesDatabaseProtocol.Type
    
    init(
        recipesApi: RecipesApiProtocol.Type,
        recipesDatabase: RecipesDatabaseProtocol.Type
    ) {
        self.recipesApi = recipesApi
        self.recipesDatabase = recipesDatabase
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
    
    func favorite(recipe: Recipe) throws {
        recipe.isFavorited = true
        try self.recipesDatabase.save(recipe)
    }
    
    func unfavorite(recipe: Recipe) throws {
        recipe.isFavorited = false
        try self.recipesDatabase.save(recipe)
    }
}
