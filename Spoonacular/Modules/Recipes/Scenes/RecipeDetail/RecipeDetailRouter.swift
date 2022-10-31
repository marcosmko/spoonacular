//
//  RecipeDetailRouter.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 21/10/22.
//

import Foundation

protocol RecipeDetailRouterProtocol: NSObjectProtocol {
}

protocol RecipeDetailDataPassing: AnyObject {
    var dataStore: RecipeDetailDataStore? { get set }
}

class RecipeDetailRouter: NSObject, RecipeDetailRouterProtocol, RecipeDetailDataPassing {
    weak var view: Ref<RecipeDetailDisplayLogic>?
    var dataStore: RecipeDetailDataStore?
}
