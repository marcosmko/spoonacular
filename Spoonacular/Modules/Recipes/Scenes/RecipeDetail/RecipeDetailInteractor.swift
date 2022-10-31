//
//  RecipeDetailInteractor.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 21/10/22.
//

import Foundation

protocol InteractorProtocol {
}

protocol RecipeDetailInteractorProtocol: InteractorProtocol {
    func get(request: RecipeDetailModel.GetRecipe.Request)
}

protocol RecipeDetailDataStore {
    var recipe: Recipe? { get set }
}

class RecipeDetailInteractor: RecipeDetailInteractorProtocol, RecipeDetailDataStore {
    var presenter: RecipeDetailPresenterProtocol?
    
    var recipe: Recipe?
    
    func get(request: RecipeDetailModel.GetRecipe.Request) {
        Task {
            guard let recipe else {
                return
            }
            
            if recipe.summary == nil {
                let apikey = "68dacdce560d4598baf62743ea86a9a7"
                let url: String = "https://api.spoonacular.com/recipes/\(recipe.id)/information?apiKey=\(apikey)"
                
                let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: url)!))
                recipe.summary = try JSONDecoder().decode(Recipe.self, from: data).summary
            }
            
            await self.presenter?.present(response: RecipeDetailModel.GetRecipe.Response(recipe: recipe))
        }
    }
}
