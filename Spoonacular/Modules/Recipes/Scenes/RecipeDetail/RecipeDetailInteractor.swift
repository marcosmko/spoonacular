//
//  RecipeDetailInteractor.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

protocol InteractorProtocol {
}

protocol RecipeDetailInteractorProtocol: InteractorProtocol {
    func get(request: RecipeDetailModel.GetRecipe.Request)
    func set(request: RecipeDetailModel.SetFavorite.Request)
}

protocol RecipeDetailDataStore {
    var recipe: Recipe? { get set }
}

class RecipeDetailInteractor: RecipeDetailInteractorProtocol, RecipeDetailDataStore {
    var presenter: RecipeDetailPresenterProtocol?
    
    var recipe: Recipe?
    
    let worker: RecipeWorker
    init(
        worker: RecipeWorker = RecipeWorker(
            recipesApi: RecipesApiService.self,
            recipesDatabase: RecipesDatabaseService.self
        )
    ) {
        self.worker = worker
    }
    
    func get(request: RecipeDetailModel.GetRecipe.Request) {
        Task {
            guard let recipe else {
                return
            }
            
            if recipe.summary == nil {
                recipe.summary = try self.worker.getRecipe(id: recipe.id).summary
            }
            
            await self.presenter?.present(response: RecipeDetailModel.GetRecipe.Response(recipe: recipe))
        }
    }
    
    func set(request: RecipeDetailModel.SetFavorite.Request) {
        Task {
            guard let recipe else {
                return
            }
            
            recipe.isFavorited
                ? try self.worker.unfavorite(recipe: recipe)
                : try self.worker.favorite(recipe: recipe)
            
            self.get(request: RecipeDetailModel.GetRecipe.Request())
        }
    }
}
