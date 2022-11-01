//
//  RecipeDetailScene.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 26/10/22.
//

import SwiftUI
import Combine

@MainActor
protocol RecipeDetailDisplayLogic {
    func display(viewModel: RecipeDetailModel.GetRecipe.ViewModel)
}

struct RecipeDetailScene: View, RecipeDetailDisplayLogic {
    lazy var view: Ref<RecipeDetailDisplayLogic> = Ref(self)
    var interactor: (any RecipeDetailInteractorProtocol)?
    var router: (RecipeDetailRouterProtocol & RecipeDetailDataPassing)?
    
    init() {
        let interactor = RecipeDetailInteractor()
        let presenter = RecipeDetailPresenter()
        let router = RecipeDetailRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.view = self.view
        router.dataStore = interactor
        router.view = self.view
    }
    
    @ObservedObject private var viewModel: DisplayingData = DisplayingData()
    private class DisplayingData: ObservableObject {
        @Published var image: URL?
        @Published var title: String = ""
        @Published var summary: AttributedString = ""
        @Published var isFavorited: Bool = false
    }
    
    func display(viewModel: RecipeDetailModel.GetRecipe.ViewModel) {
        self.viewModel.image = viewModel.image
        self.viewModel.title = viewModel.title
        self.viewModel.summary = viewModel.summary.with(font: .system(size: 16))
        self.viewModel.isFavorited = viewModel.isFavorited
    }
    
    var body: some View {
        if self.viewModel.title == "" {
            ProgressView()
                .navigationTitle("Recipe")
                .onAppear() {
                    interactor?.get(request: RecipeDetailModel.GetRecipe.Request())
                }
        } else {
            ScrollView {
                VStack {
                    if let image = viewModel.image {
                        AsyncImage(
                            url: image, content: { image in
                                image.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 400)
                                    
                            }
                        )
                        Spacer().frame(height: 20)
                    }
                    Text(viewModel.title)
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: 20)
                    Text(viewModel.summary)
                }
                .padding(20)
            }
            .navigationTitle("Recipe")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        interactor?.set(request: RecipeDetailModel.SetFavorite.Request())
                    } label: {
                        Image(systemName: viewModel.isFavorited ? "star.fill" : "star")
                    }

                }
            })
        }
    }
}

struct RecipeDetailScene_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailScene()
    }
}
