//
//  RecipeDetailPresenter.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import SwiftUI

protocol RecipeDetailPresenterProtocol {
    func present(response: RecipeDetailModel.GetRecipe.Response) async
}

class RecipeDetailPresenter: RecipeDetailPresenterProtocol {
    weak var view: Ref<RecipeDetailDisplayLogic>?
    
    func present(response: RecipeDetailModel.GetRecipe.Response) async {
        // convert summary to data
        guard let data = (response.recipe.summary ?? "").data(using: .utf8) else {
            return
        }
        do {
            // transform html summary in attributed string
            let summary = try NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
            
            await self.view?.value.display(viewModel: RecipeDetailModel.GetRecipe.ViewModel(
                image: response.recipe.image,
                title: response.recipe.title,
                summary: AttributedString(summary)
            ))
        } catch {
            // show error message
        }
    }
}
