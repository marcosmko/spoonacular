//
//  RecipeListScene.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 26/10/22.
//

import SwiftUI
import Combine

@MainActor
protocol RecipeListDisplayLogic {
    func display(viewModel: RecipeListModel.GetRecipes.ViewModel)
}

struct RecipeListScene: View, RecipeListDisplayLogic {
    lazy var view: Ref<RecipeListDisplayLogic> = Ref(self)
    var interactor: (any RecipeListInteractorProtocol)?
    var router: (RecipeListRouterProtocol & RecipeListDataPassing)?
    
    init() {
        let interactor = RecipeListInteractor()
        let presenter = RecipeListPresenter()
        let router = RecipeListRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.view = self.view
        router.dataStore = interactor
        router.view = self.view
    }
    
    @State private var searchText = ""
    
    @ObservedObject private var viewModel: DisplayingData = DisplayingData()
    private class DisplayingData: ObservableObject {
        @Published var recipes: [RecipeListModel.GetRecipes.ViewModel.DisplayedCell] = []
    }
    
    func display(viewModel: RecipeListModel.GetRecipes.ViewModel) {
        self.viewModel.recipes = viewModel.recipes
    }
    
    func routeToRecipeDetailScene(index: Int) -> RecipeDetailScene {
        let scene = RecipeDetailScene()
        scene.router?.dataStore?.recipe = router?.dataStore?.recipes[index]
        return scene
    }
    
    var body: some View {
        NavigationStack {
            List(Array(viewModel.recipes.enumerated()), id: \.offset) { index, element in
                NavigationLink(element.title) {
                    routeToRecipeDetailScene(index: index)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Recipes")
        }
        .onSubmit(of: .search, {
            interactor?.get(request: RecipeListModel.GetRecipes.Request(text: searchText))
        })
        .onAppear() {
            interactor?.get(request: RecipeListModel.GetRecipes.Request(text: searchText))
        }
    }
}

struct RecipeListScene_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListScene()
    }
}
