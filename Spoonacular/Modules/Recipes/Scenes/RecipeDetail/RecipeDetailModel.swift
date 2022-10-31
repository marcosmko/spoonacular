//
//  RecipeDetailModel.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 21/10/22.
//

import Foundation

enum RecipeDetailModel {
    enum GetRecipe {
        struct Request {
        }
        struct Response {
            let recipe: Recipe
        }
        struct ViewModel {
            let image: URL?
            let title: String
            let summary: AttributedString
        }
    }
}