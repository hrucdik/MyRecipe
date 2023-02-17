//
//  Persistence.swift
//  MyRecipe
//
//  Created by 堀内大希 on 2023/01/30.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let newMemo = Memo(context: viewContext)
        newMemo.memo = "テスト"
        
        
        let sampleImage0: UIImage = UIImage(named: "pizza") ?? UIImage(systemName: "photo")!
        let sampleImage1: UIImage = UIImage(systemName: "photo")!
        
        let newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.title = "タイトル"
        
        if newRecipe.image == nil {
            newRecipe.image = sampleImage0.jpegData(compressionQuality: 1)
        } else {
            newRecipe.image = sampleImage1.pngData()
        }
        newRecipe.ingredient = "じゃがいも\nたまねぎ\nにんじん"
        newRecipe.procedure = "焼く\n煮る\n炒める"
        newRecipe.category = "その他"
        
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyRecipe")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
