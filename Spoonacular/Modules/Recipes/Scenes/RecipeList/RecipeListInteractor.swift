//
//  RecipeListInteractor.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

protocol RecipeListInteractorProtocol: InteractorProtocol {
    func get(request: RecipeListModel.GetRecipes.Request)
}

protocol RecipeListDataStore {
    var recipes: [Recipe] { get set }
}

class RecipeListInteractor: RecipeListInteractorProtocol, RecipeListDataStore {
    var presenter: RecipeListPresenterProtocol?
    
    var recipes: [Recipe] = []
    
    let worker: RecipeWorker
    init(
        worker: RecipeWorker = RecipeWorker(
            recipesApi: RecipesApiService.self,
            recipesDatabase: RecipesDatabaseService.self
        )
    ) {
        self.worker = worker
    }
    
    func get(request: RecipeListModel.GetRecipes.Request) {
        Task {
            self.recipes = try self.worker.getRecipes(query: request.text)
            await self.presenter?.present(response: RecipeListModel.GetRecipes.Response(
                recipes: self.recipes
            ))
        }
    }
}
