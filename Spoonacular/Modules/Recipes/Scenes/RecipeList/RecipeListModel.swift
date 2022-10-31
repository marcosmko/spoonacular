//
//  RecipeListModel.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 21/10/22.
//

import Foundation

enum RecipeListModel {
    enum GetRecipes {
        struct Request {
            let text: String
        }
        struct Response {
            let recipes: [Recipe]
        }
        struct ViewModel {
            struct DisplayedCell {
                let title: String
            }
            let recipes: [DisplayedCell]
        }
    }
}
