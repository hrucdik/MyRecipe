//
//  EmptyView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/02/13.
//

import SwiftUI

struct EmptyView: View {
    // MARK: - properties
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .center) {
            Image("list")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(Color("tintColor"))
                .frame(width: 150, height: 150, alignment: .center)
                .padding(.leading, 20)
            
            Text("タスクはありません")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Color("tintColor"))
                .padding()
        } //: vstack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("backgroundColor"))
    }
}

// MARK: - preview

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
