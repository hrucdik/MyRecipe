//
//  HomeView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/01/30.
//

import SwiftUI
import CoreData

struct HomeView: View {
    // MARK: - properties
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismissSearch) var dismissSearch
    
    @FetchRequest(
        entity: Recipe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.title, ascending: true)])
    private var items: FetchedResults<Recipe>
    
    @State private var image: Data = .init(count: 0)
    @State private var searchText: String = ""
    @State private var searchCategories: String = ""
    let placeholder: String = "タイトル・カテゴリー名で検索"
    @State private var category: String = "レシピ一覧"
    @State private var errorTitle: String = "レシピを全て削除してよろしいですか？"
    @State private var showingAlert: Bool = false
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    let categories = ["レシピ一覧", "ごはんもの", "サラダ", "卵料理", "鍋料理", "麺料理", "肉料理", "魚料理", "スープ・汁物", "パン", "デザート", "ドリンク", "その他"]
    
    
    // MARK: - function
    
    private func search(text: String) {
        if text.isEmpty {
            items.nsPredicate = nil
        } else {
            let titlePredicate: NSPredicate = NSPredicate(format: "title contains %@", text)
            let categoryPredicate: NSPredicate = NSPredicate(format: "category contains %@", text)
            items.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, categoryPredicate])
        }
    }
    
    private func searchCategory(text: String) {
        if text == "レシピ一覧" {
            items.nsPredicate = nil
        } else {
            let categoryPredicate: NSPredicate = NSPredicate(format: "category contains %@", text)
            items.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:[categoryPredicate])
        }
    }
    
    private func allDelete() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Recipe")


        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )

        deleteRequest.resultType = .resultTypeObjectIDs

        let batchDelete = try? viewContext.execute(deleteRequest)
            as? NSBatchDeleteResult

        guard let deleteResult = batchDelete?.result
            as? [NSManagedObjectID]
            else { return }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [viewContext]
        )
    }
    
    // MARK: - body
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Text("Recipes List")
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("tintColor"))
                        .padding(.leading, 25)
                        .padding(.top)
                    
                    Text(category)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("tintColor"))
                        .padding(.top)
                        .padding(.horizontal, 10)
                        .overlay(
                            Capsule()
                                .stroke(Color("tintColor").opacity(0.5), lineWidth: 2)
                                .padding(.top)
                                .frame(height: 45)
                        )
                        
                    
                    Spacer()
                    
                    Group {
                        Image("square.fill")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("recipesNumber"))
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 26)
                            .padding(.top, 14)
                    }
                    .overlay(
                        Group {
                            if items.count == 0 {
                                Text("0")
                                    .modifier(RecipesListNumber())
                            } else {
                                Text("\(items.count)")
                                    .modifier(RecipesListNumber())
                            }
                        }.foregroundColor(Color("NumberColor"))
                    )
                } //: hstack
                
                if items.count == 0 {
                    EmptyRecipeView()
                        .padding(.top, 70)
                }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) { save in
                        NavigationLink(destination: RecipeDetailView(sample: save)) {
                            if save.image != nil {
                                Group {
                                    Image(uiImage: UIImage(data: save.image ?? self.image)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 210)
                                        .overlay(alignment: .bottom) {
                                            Text(save.title ?? "Unknown")
                                                .modifier(CardTitleModifier())
                                        }
                                } //: group
                                .modifier(RecipeCardModifier())
                            } else {
                                Group {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40, alignment: .center)
                                        .foregroundColor(.white.opacity(0.7))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .overlay(alignment: .bottom) {
                                            Text(save.title ?? "Unknown")
                                                .modifier(CardTitleModifier())
                                        }
                                } //: group
                                .frame(width: 160, height: 200, alignment: .top)
                                .modifier(RecipeCardModifier())
                            }
                        } //: link
                    } //: loop
                } //: lazygrid
                .padding(.top)
                .padding(.horizontal, 14)
            } //: scroll
            .navigationTitle("My Recipes")
            .navigationBarTitleDisplayMode(.large)
            .background(Color("backgroundColor"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(categories, id: \.self) { itemMenu in
                            Button(itemMenu, action: {
                                self.searchCategories = itemMenu
                                self.category = itemMenu
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    searchCategory(text: searchCategories)
                                }
                            })
                        }
                    } label: {
                        Image("tag")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 33, height: 33)
                            .foregroundColor(Color("tintColor"))
                            .padding(4)
                    }
                }
                
                // MARK: - All delete button (alert)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.showingAlert = true
                    } label: {
                        Image("trash")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("tintColor"))
                            .fontWeight(.semibold)
                            .scaledToFit()
                            .frame(width: 33, height: 33)
                    }
                    .alert(Text(errorTitle), isPresented: $showingAlert) {
                        Button("キャンセル", role: .cancel) {
                            // 処理なし
                        }
                        // MARK: - recipe all delete button
                        Button("削除", role: .destructive) {
                            allDelete()
                        } //: recipe all delete button
                    } //: alert
                } //: all delete button
            } //: toolbar
            
        } //: navigation
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: placeholder)
        .onChange(of: searchText) { newValue in
            search(text: newValue)
        }
    }
}

// MARK: - preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
