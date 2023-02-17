//
//  TabItemView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/01/30.
//

import SwiftUI

struct TabItemView: View {
    // MARK: - properties
    
    var body: some View {
            TabView {
                // MARK: - レシピ一覧画面
                HomeView()
                    .tabItem {
                        Image(systemName: "fork.knife")
                        Text("レシピ")
                    }
                
                // MARK: - レシピ追加画面
                NewRecipeView()
                    .tabItem {
                        Image(systemName: "plus")
                        Text("追加")
                    }
                
                 // MARK: - メモ画面
                MemoView()
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("メモ")
                    }
            } //: Tabview
            .tint(Color("tintColor"))
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
