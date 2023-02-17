//
//  RecipeDetailView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/02/02.
//

import SwiftUI
import CoreData

struct RecipeDetailView: View {
    // MARK: - properties
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(
        entity: Recipe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.objectID, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Recipe>
    
    @State private var image: Data = .init(count: 0)
    @State private var showingAlert: Bool = false
    @State private var showingAlert2: Bool = false
    @State private var deleteAction: Bool = false
    @State private var errorTitle: String = "削除してよろしいですか？"
    
    @ObservedObject var sample: Recipe
    
    // MARK: - function
    
    private func deleteRecipe(recipe: Recipe){
        
        viewContext.delete(recipe)
        
        do{
            try viewContext.save()
            
        }catch{
            print(error)
        }
    }
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            ScrollView(.vertical ,showsIndicators: false) {
                LazyVStack(alignment: .center, spacing: 15, pinnedViews: [.sectionHeaders]) {
                    
                    GeometryReader { proxy in
                        
                        let minY = proxy.frame(in: .named("scroll")).minY
                        let size = proxy.size
                        let height = (size.height + minY)
                        
                        
                        
                        if sample.image != nil {
                            Image(uiImage: UIImage(data: sample.image ?? self.image)!)
                                .resizable()
                                .scaledToFill()
                            
                                .frame(width: size.width, height: abs(height))
                            //frameで指定したサイズで切り取る
                                .clipShape(Rectangle())
                                .offset(y: -minY)
                            
                        } else {
                            Group {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .foregroundColor(.white.opacity(0.5))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.top, 10)
                            } //: group
                            //.frame(height: 330)
                            .frame(width: size.width, height: abs(height))
                            .background(LinearGradient(gradient: Gradient(colors: [Color(.gray), Color(.gray).opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                            .offset(y: -minY)
                        }
                    } //: GeometryReader
                    .frame(height: 315)
                } //: LazyVStack
                
                VStack(spacing: 17) {
                    Spacer().padding(.vertical, 10)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        
                        // MARK: - ingredient
                        if sample.ingredient != "" {
                            HStack {
                                Text("材料")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Button {
                                    self.showingAlert2 = true
                                    self.errorTitle = "材料をメモに追加しますか？"
                                    
                                } label: {
                                    Image(systemName: "cart")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .padding(.trailing, 15)
                                }
                                .alert(Text(errorTitle), isPresented: $showingAlert2) {
                                    Button("キャンセル") {
                                        // 処理なし
                                    }
                                    
                                    // MARK: - add Button (Memo)
                                    Button("OK") {
                                        let array = sample.ingredient!.split(whereSeparator: \.isNewline)
                                        let stringRecipe = array.map(String.init)
                                        
                                        for (_, item) in stringRecipe.enumerated() {
                                            
                                            let newMemo = Memo(context: viewContext)
                                            newMemo.id = UUID()
                                            newMemo.memo = item
                                            
                                            do {
                                                try viewContext.save()
                                            } catch {
                                                let nsError = error as NSError
                                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                            }
                                        } //: loop
                                    } //: addMemoButton
                                } //: alert
                            } //: hstack
                            
                            Divider().background(Color("foregroundColor"))
                            
                            Text(sample.ingredient ?? "材料 1\n材料 2\n材料 3")
                                .lineSpacing(10)
                        } //: ingredient
                        
                        Spacer()
                        
                        // MARK: - procedure
                        if sample.procedure != "" {
                            Text("作り方")
                                .font(.headline)
                            
                            Divider().background(Color("foregroundColor"))
                            
                            Text(sample.procedure ?? "作り方 1\n作り方 2\n作り方 3")
                                .lineSpacing(10)
                            
                        } //: procedure
                    } //: vstack
                    .foregroundColor(Color("foregroundColor"))
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                } //: vstack
                .background(
                    Color("backgroundColor")
                        .clipShape(CustomShape())
                        .padding(.top, -60)
                )
                .overlay(
                    HStack {
                        Text(sample.title ?? "Unknown")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color("foregroundColor"))
                            .multilineTextAlignment(.center)
                            .padding(.leading, 18)
                            .padding(.top, -22)
                            .lineLimit(2)
                        
                        Text(sample.category ?? "Unknown")
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundColor(Color("tintColor"))
                            .padding(.vertical, 7)
                            .padding(.horizontal, 10)
                            .frame(minWidth: 42)
                            .overlay(
                                Capsule().stroke(Color("tintColor").opacity(0.5), lineWidth: 2)
                                
                            )
                            .padding(.top, -20)
                    } //: hstack
                    ,alignment: .topLeading
                )
            } //: scroll
            .background(Color("backgroundColor"))
        } //: zstack
        .coordinateSpace(name: "scroll")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAlert = true
                    
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 20, weight: .bold))
                }
                .alert(Text(errorTitle), isPresented: $showingAlert) {
                    Button("キャンセル", role: .cancel) {
                        // 処理なし
                    }
                    
                    // MARK: - delete button
                    Button("削除", role: .destructive) {
                        deleteRecipe(recipe: sample)
                        dismiss()
                    }
                } //: alert
            }
            
            // MARK: - dismiss button
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 22, weight: .bold))
                }
            }
        }
        .tint(Color("tintColor"))
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - preview

struct RecipeDetailView_Previews: PreviewProvider {
    static let entity = NSManagedObjectModel.mergedModel(from: nil)?.entitiesByName["Recipe"]
    
    static var previews: some View {
        
        let task = Recipe(entity: entity!, insertInto: nil)
        
        return RecipeDetailView(sample: task)
    }
}

