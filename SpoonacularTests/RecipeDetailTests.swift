//
//  SpoonacularTests.swift
//  SpoonacularTests
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import XCTest
@testable import Spoonacular

final class RecipeDetailTests: XCTestCase {
    
    class RecipesApiService: RecipesApiProtocol {
        static func getComplexSearch(query: String) throws -> [Recipe] {
            return []
        }
        static func getRecipe(id: Int) throws -> Recipe {
            return Recipe()
        }
        static func getRandomRecipes() throws -> [Recipe] {
            return []
        }
    }
    
    class RecipesDatabaseService: RecipesDatabaseProtocol {
        static func fetchAll() throws -> [Recipe] {
            return []
        }
        static func save(_ object: Recipe) throws {
        }
        static func delete(_ object: Recipe) throws {
        }
    }
    
    func testPresentRecipe() throws {
        let presenterRecipeExpectation = expectation(description: "PresentRecipe")
        
        class PresenterMock: RecipeDetailPresenterProtocol {
            var presenterRecipeExpectation: XCTestExpectation!
            var didCallPresenterRecipe: Bool = false
            
            func present(response: RecipeDetailModel.GetRecipe.Response) async {
                didCallPresenterRecipe = true
                presenterRecipeExpectation.fulfill()
            }
        }
        
        let recipe = Recipe()
        recipe.title = "Title"
        recipe.summary = "Summary"
        
        let interactor = RecipeDetailInteractor(
            worker: RecipeWorker(
                recipesApi: RecipesApiService.self,
                recipesDatabase: RecipesDatabaseService.self
            )
        )
        interactor.recipe = recipe
        
        let presenterMock = PresenterMock()
        presenterMock.presenterRecipeExpectation = presenterRecipeExpectation
        
        interactor.presenter = presenterMock
        interactor.get(request: RecipeDetailModel.GetRecipe.Request())
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(presenterMock.didCallPresenterRecipe, true)
        }
    }
}
