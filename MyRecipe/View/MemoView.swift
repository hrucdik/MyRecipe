//
//  ContentView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/01/30.
//

import SwiftUI
import CoreData

struct MemoView: View {
    // MARK: - properties
    
    @Environment(\.managedObjectContext) private var viewContext
     
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Memo.memo, ascending: true)],
        animation: .default)
    private var memoItem: FetchedResults<Memo>
    
    @State private var memo: String = ""
    @State private var showNewTaskItem: Bool = false
    @State private var isAnimating: Bool = false
    @State private var opacity: Double = 0.0
    
    @State private var errorTitle: String = "全て削除してよろしいですか？"
    @State private var showingAlert: Bool = false
   
    // MARK: - function
    
    private func addMemo() {
        withAnimation {
            let addMemo = Memo(context: viewContext)
            addMemo.memo = self.memo
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { memoItem[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func allDelete() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Memo")
        
        
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
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea(.all)
                
                // MARK: - Empty View
                if memoItem.count == 0 {
                    EmptyView()
                        .ignoresSafeArea(.keyboard, edges: .all)
                }
                
                // MARK: - todo list
                List {
                    ForEach(memoItem, id: \.self) { item in
                        Text(item.memo ?? "nil")
                            .listRowBackground(Color(UIColor.tertiarySystemFill).opacity(0.7))
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                    } //: loop
                    .onDelete(perform: deleteItems)
                } //: List
                .scrollContentBackground(.hidden)
                .environment(\.defaultMinListRowHeight, 55)
                .contentShape(Rectangle())
                .blur(radius: showNewTaskItem ? 4.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5), value: showNewTaskItem)
                .overlay(
                    Button(action: {
                        showNewTaskItem = true
                        withAnimation(.easeInOut(duration: 0.4)) {
                            isAnimating = true
                            opacity = 1.0
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .fontWeight(.semibold)
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(Color("taskSaveButton"))
                            .clipShape(Circle())
                    })
                    .padding(60)
                    , alignment: .bottomTrailing
                )
                .ignoresSafeArea(.keyboard, edges: .all)
                
                // MARK: - New task view
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: Color("unknownColor"),
                        backgroundOpacity: 0.3)
                    .onTapGesture {
                        withAnimation() {
                            showNewTaskItem = false
                            isAnimating = false
                            opacity = 0.0
                        }
                    }
                    NewTaskView(isShowing: $showNewTaskItem)
                        .offset(y:isAnimating ? 0 : 40)
                        .opacity(opacity)
                }
            } //: zstack
            .navigationTitle("Todo リスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    CustomEditButton()
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAlert = true
                    } label: {
                        Image("trash")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("tintColor"))
                            .fontWeight(.semibold)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .alert(Text(errorTitle), isPresented: $showingAlert) {
                        Button("キャンセル", role: .cancel) {
                            // 処理なし
                        }
                        // MARK: - recipe all delete button
                        Button("削除", role: .destructive) {
                            allDelete()
                        } //: all delete button (Memo)
                    }
                }
                
            } //: toolbar
            .tint(Color("tintColor"))
        } //: navigation
    }
}

// MARK: - preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MemoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
