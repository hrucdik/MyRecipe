//
//  BlankView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/02/12.
//

import SwiftUI

struct BlankView: View {
    
    // MARK: - properties
    
    var backgroundColor: Color
    var backgroundOpacity: Double
    
    // MARK: - body
    
    var body: some View {
        VStack {
            Spacer()
        } //: vstack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(backgroundColor)
        .opacity(backgroundOpacity)
        .ignoresSafeArea(.all)
    }
}

// MARK: - preview

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView(backgroundColor: Color.gray, backgroundOpacity: 0.5)
    }
}
