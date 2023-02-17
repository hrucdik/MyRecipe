//
//  AddRecipeView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/01/30.
//

import SwiftUI
import PhotosUI


struct AddRecipeView: View {
    // MARK: - properties
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var uiImage: UIImage?
    @State private var ingredient: String = ""
    @State private var procedure: String = ""
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var editor: TextEditor?
    
    @State private var checkTitleEmpty: Bool = false
    
    @State private var selectedItem1: PhotosPickerItem?
    @State private var uiImage1: UIImage?
    @State private var selectedItem2: PhotosPickerItem?
    @State private var uiImage2: UIImage?
    
    
    @State private var category: String = "ごはんもの"
    let categories = ["ごはんもの", "サラダ", "卵料理", "鍋料理", "麺料理", "肉料理", "魚料理", "スープ・汁物", "パン", "デザート", "ドリンク", "その他"]
    
    @FocusState var focus : Focus?
    
    enum Focus: Hashable {
        case title
        case ingredient
        case procedure
    }
    
    // MARK: - function
    
    private func addRecipe() {
        let newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.title = self.title
        newRecipe.image = self.selectedImageData
        newRecipe.category = self.category
        newRecipe.ingredient = self.ingredient
        newRecipe.procedure = self.procedure
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    // MARK: - body
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 25) {
                        
                        Spacer().frame(height: 0)
                        
                        // MARK: - title
                        
                        TextField(text: $title) {
                            Text("Title")
                                .foregroundColor(checkTitleEmpty ? Color.red.opacity(0.3) : Color.gray.opacity(0.3))
                        }
                        .padding()
                        .frame(width: 350, height: 60)
                        .font(.system(size: 35))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(checkTitleEmpty ? Color.red : Color.clear)
                        )
                        .onChange(of: title, perform: { _ in
                            self.checkTitleEmpty = false
                        })
                        // PhotosPickerの画像選択後、タイトルを入力できない時の対処法
                        .focused($focus, equals: .title)
                        .onTapGesture {
                            focus = .title
                        }
                        .id(0)
                        
                        // MARK: - Image
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            if uiImage == nil {
                                Group {
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.system(size: 35))
                                        Text("add a photo")
                                            .padding(.top, 4)
                                            .font(.system(size: 24))
                                    } //: vstack
                                } //: group
                                .frame(width: 350, height: 200)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("unknownImage"))
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color("editorBackground"))
                                        .shadow(color: Color("shadowColor").opacity(0.1), radius: 8, x: 3, y: 6)
                                )
                                
                                
                            } else {
                                Image(uiImage: uiImage ?? UIImage(systemName: "photo")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 350, height: 200)
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .strokeBorder(Color.black, lineWidth: 2)
                                    )
                            }
                        } //: photospicker
                        .padding(.top, -10)
                        .padding(.bottom, 20)
                        .onChange(of: selectedItem) { newImageData in
                            Task {
                                if let imageData = try? await newImageData?.loadTransferable(type: Data.self) {
                                    selectedImageData = imageData
                                    uiImage = UIImage(data: imageData)
                                }
                            }
                        }
                        
                        
                        // MARK: - Category
                        
                        HStack {
                            Text("カテゴリー")
                                .padding(.leading, 5)
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundColor(Color("tintColor"))
                            Spacer()
                            Picker("カテゴリー", selection: $category) {
                                ForEach(categories, id: \.self) {
                                    Text($0)
                                } //: loop
                            } //: picker
                            .pickerStyle(.menu)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color("editorBackground"))
                            )
                            
                            
                        } //: hstack
                        .frame(width: 350, height: 50)
                        
                        // MARK: - ingredient
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
//                            HStack {
                                Text("材料")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(Color("tintColor"))
//
                            
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $ingredient).id(1)
                                    .modifier(TextEditorCustom())
                                    .focused($focus, equals: .ingredient)
                                    .contentShape(RoundedRectangle(cornerRadius: 25))
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(1, anchor: .center)
                                            focus = .ingredient
                                        }
                                    }
                                    
                                // MARK: - placeholder
                                if ingredient.isEmpty {
                                    Text("じゃがいも 2個\nにんじん 1本")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .padding(.leading, -3)
                                        .padding(25)
                                        .foregroundColor(Color(UIColor.placeholderText))
                                        .lineSpacing(8)
                                        .frame(width: 350, alignment: .leading)
                                }
                            } //: zstack
                        } //: ingredient
                        
                        // MARK: - procedure
                        
                        VStack(alignment: .leading, spacing: 10) {
//                            HStack {
                                Text("作り方")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(Color("tintColor"))
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $procedure).id(2)
                                    .modifier(TextEditorCustom())
                                    .focused($focus, equals: .procedure)
                                    .contentShape(RoundedRectangle(cornerRadius: 25))
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(2, anchor: .center)
                                            focus = .procedure
                                        }
                                    }
                                    
                                
                                // MARK: - placeholder
                                if procedure.isEmpty {
                                    Text("じゃがいも、にんじんを洗う。")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .padding(.leading, -3)
                                        .padding(25)
                                        .foregroundColor(Color(UIColor.placeholderText))
                                        .lineSpacing(8)
                                        .frame(width: 350, alignment: .leading)
                                }
                            } //: zstack
                        } //: procedure
                    } //: vstack
                    .frame(maxWidth: .infinity)
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle("New Recipe")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        
                        // MARK: - dismiss button
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        } //: dismiss button
                        
                        // MARK: - save button
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if self.title != "" {
                                    addRecipe()
                                } else {
                                    self.errorShowing = true
                                    self.errorTitle = "タイトルが入力されていません"
                                    self.checkTitleEmpty = true
                                    proxy.scrollTo(0, anchor: .center)
                                    
                                    return
                                }
                                
                                dismiss()
                            } label: {
                                Image(systemName: "checkmark")
                            }
                        } //: save button
                    } //: toolbar
                    .alert(Text(errorTitle), isPresented: $errorShowing) {}
                } //: scroll
                .frame(maxWidth: .infinity)
                .background(Color("addRecipeBackground"))
                // 任意の場所をタップしたらキーボードを閉じる
                .onTapGesture {
                    self.focus = nil
                }
            } //: scrollReader
        } //: navigation
        .tint(Color("tintColor"))
    }
}

// MARK: - preview

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
