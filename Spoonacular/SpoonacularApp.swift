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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
