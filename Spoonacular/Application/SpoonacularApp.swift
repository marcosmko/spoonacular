//
//  SpoonacularApp.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import SwiftUI

@main
struct SpoonacularApp: App {
    let persistenceController = PersistenceController.shared
    @State var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .task {
                        try? await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                        self.showSplash = false
                    }
            } else {
                RecipeListScene()
//                ContentView()
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
