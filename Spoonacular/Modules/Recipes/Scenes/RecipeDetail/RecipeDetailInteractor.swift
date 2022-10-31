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
        struct Recipes: Decodable {
            let recipes: [Recipe]?
            let results: [Recipe]?
        }
        Task {
            guard let recipe else {
                return
            }
            let apikey = "68dacdce560d4598baf62743ea86a9a7"
            let url: String = "https://api.spoonacular.com/recipes/random?number=10&apiKey=\(apikey)"
            
//            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: url)!))
//            if let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
//                let string = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) {
//                print(String(data: string, encoding: .utf8) as! NSString)
//            }
//            
//            let recipes: Recipes = try! JSONDecoder().decode(Recipes.self, from: data)
//            print(recipes)
//            self.recipes = recipes.recipes ?? recipes.results ?? []
            
            await self.presenter?.present(response: RecipeDetailModel.GetRecipe.Response(recipe: recipe))
        }
    }
}
