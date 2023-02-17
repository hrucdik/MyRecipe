//
//  MyRecipeApp.swift
//  MyRecipe
//
//  Created by horiuchi. on 2023/01/30.
//

import SwiftUI

@main
struct MyRecipeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabItemView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
