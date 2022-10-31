//
//  RecipesApiService.swift
//  McDonalds
//
//  Created by Marcos Kobuchi on 25/10/22.
//

import Foundation

class RecipesApiService: WebApiService {
    override class var controller: String { "recipes" }
}

extension RecipesApiService: RecipesApiProtocol {
    static func getRandomRecipes() throws -> [Recipe] {
        struct Recipes: Decodable {
            let recipes: [Recipe]
        }
        let response: Recipes = try self.request(Request.get("random", params: ["number": 10]))
        return response.recipes
    }
    
    static func getComplexSearch(query: String) throws -> [Recipe] {
        struct Recipes: Decodable {
            let results: [Recipe]
        }
        let response: Recipes = try self.request(Request.get("complexSearch", params: ["query": query]))
        return response.results
    }
    
    static func getRecipe(id: Int) throws -> Recipe {
        return try self.request(Request.get("\(id)/information"))
    }
}
