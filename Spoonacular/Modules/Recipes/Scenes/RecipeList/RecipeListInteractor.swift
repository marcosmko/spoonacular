//
//  RecipeListInteractor.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 21/10/22.
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
    
    func get(request: RecipeListModel.GetRecipes.Request) {
        struct Recipes: Decodable {
            let recipes: [Recipe]?
            let results: [Recipe]?
        }
        Task {
            let apikey = "68dacdce560d4598baf62743ea86a9a7"
            let url: String
            if request.text.isEmpty {
                url = "https://api.spoonacular.com/recipes/random?number=10&apiKey=\(apikey)"
            } else {
                url = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apikey)&query=\(request.text)"
            }
            
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: url)!))
//            if let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
//                let string = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) {
//                print(String(data: string, encoding: .utf8) as! NSString)
//            }
            
            let recipes: Recipes = try JSONDecoder().decode(Recipes.self, from: data)
            self.recipes = recipes.recipes ?? recipes.results ?? []
            
            await self.presenter?.present(response: RecipeListModel.GetRecipes.Response(
                recipes: self.recipes
            ))
        }
    }
}
