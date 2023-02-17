//
//  EmptyRecipeView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/02/14.
//

import SwiftUI

struct EmptyRecipeView: View {
    // MARK: - properties
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .center) {
            Image("book")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 260, height: 260)
            
            Text("レシピはありません")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .padding(.top, -20)
        } //: vstack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .foregroundColor(Color("tintColor"))
    }
}

// MARK: - preview

struct EmptyRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRecipeView()
    }
}
