//
//  CustomViewModifier.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/02/03.
//

import SwiftUI

// MARK: - RecipeCardTitle Modifier (HomeView)
struct CardTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .shadow(color: Color.black, radius: 3, x: 0, y: 0)
            .frame(maxWidth: 136)
            .padding()
    }
}

// MARK: - RecipeCardModifier (HomeView)
struct RecipeCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color("shadowColor").opacity(0.3), radius: 8, x: 0, y: 6)
    }
}

// MARK: - TextEditorCustomModifier (AddRecipeView)
struct TextEditorCustom: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .padding()
            .lineSpacing(8)
            .frame(width: 350, height: 230)
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(Color("tintColor"))
            .background(Color("editorBackground"))
            .cornerRadius(25)
    }
}

// MARK: - RecipesListNumber (HomeView)
struct RecipesListNumber: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .padding(.trailing, 26)
            .padding(.top, 14)
    }
}

