//
//  RecipeListRouter.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 21/10/22.
//

import Foundation

protocol RecipeListRouterProtocol: NSObjectProtocol {
}

protocol RecipeListDataPassing: AnyObject {
    var dataStore: RecipeListDataStore? { get set }
}

class RecipeListRouter: NSObject, RecipeListRouterProtocol, RecipeListDataPassing {
    weak var view: Ref<RecipeListDisplayLogic>?
    var dataStore: RecipeListDataStore?
}
