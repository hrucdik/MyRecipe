//
//  NewRecipeView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/01/30.
//

import SwiftUI

struct NewRecipeView: View {
    // MARK: - properties
    
    @State private var showAddRecipe: Bool = false
    
    // MARK: - body
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                // MARK: - add new recipe button
                Button {
                    showAddRecipe = true
                } label: {
                    VStack(alignment: .center) {
                        Image("bowl")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(Color("tintColor"))
                            .frame(width: 230, height: 230)
                            .padding(.top, -35)
                
                        Text("レシピを追加する")
                            .font(.system(size: 19, weight: .semibold, design: .rounded))
                            .padding(.top)
                    } //: vstack
                } //: add new recipe button
                .navigationDestination(isPresented: $showAddRecipe) {
                    AddRecipeView()
                }
            } //: zstack
        } //: navigation
        .tint(Color("tintColor"))
    }
}

// MARK: - preview

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView()
    }
}
