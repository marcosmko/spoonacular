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
        var recipes: [Recipe]
        if query.isEmpty {
            recipes = try self.recipesApi.getRandomRecipes()
        } else {
            recipes = try self.recipesApi.getComplexSearch(query: query)
        }
        
        // if we have in local cache, switch
        let cachedRecipes: [Recipe] = try self.recipesDatabase.fetchAll()
        for (index, recipe) in recipes.enumerated() {
            // need to check if this doesn't throw
            if let cachedRecipe = cachedRecipes.first(where: { $0.id == recipe.id }) {
                recipes[index] = cachedRecipe
            }
        }
        
        return recipes
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
