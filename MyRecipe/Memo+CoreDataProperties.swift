//
//  Memo+CoreDataProperties.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/02/12.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var memo: String?

}

extension Memo : Identifiable {

}
