//
//  NewTaskView.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/02/12.
//

import SwiftUI
import CoreData

struct NewTaskView: View {
    // MARK: - properties
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var task: String = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    @FocusState var focus : Field?
    
    enum Field: Hashable {
        case task
    }
    
    // MARK: - function
    
    private func addMemo() {
        withAnimation {
            let addMemo = Memo(context: viewContext)
            addMemo.id = UUID()
            addMemo.memo = self.task
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            focus = nil
            task = ""
            isShowing = false
        }
    }
    
    // MARK: - body
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField("New Task", text: $task)
                    .foregroundColor(Color("tintColor"))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(Color("taskBackground"))
                    .cornerRadius(10)
                    .focused($focus, equals: .task)
                
                Button {
                    addMemo()
                } label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                }
                .disabled(isButtonDisabled)
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.gray : Color("taskSaveButton"))
                .cornerRadius(10)
            } //: vstack
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(Color("taskColor"))
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 22)
        } //: vstack
        .toolbar(.hidden, for: .tabBar)
        .onTapGesture {
            focus = nil
        }
        .padding()
    }
}

// MARK: - preview

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(isShowing: .constant(true))
            .background(Color.gray.opacity(0.7).edgesIgnoringSafeArea(.all))
    }
}
