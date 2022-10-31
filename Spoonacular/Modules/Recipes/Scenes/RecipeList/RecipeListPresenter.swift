//
//  RecipeListPresenter.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 21/10/22.
//

import Foundation

protocol RecipeListPresenterProtocol {
    func present(response: RecipeListModel.GetRecipes.Response) async
}

class RecipeListPresenter: RecipeListPresenterProtocol {
    weak var view: Ref<RecipeListDisplayLogic>?
    
    func present(response: RecipeListModel.GetRecipes.Response) async {
        var displayedRecipes: [RecipeListModel.GetRecipes.ViewModel.DisplayedCell] = []
        
        for recipe in response.recipes {
            displayedRecipes.append(RecipeListModel.GetRecipes.ViewModel.DisplayedCell(
                title: recipe.title
            ))
        }
        
        await self.view?.value.display(viewModel: RecipeListModel.GetRecipes.ViewModel(
            recipes: displayedRecipes
        ))
    }
}
