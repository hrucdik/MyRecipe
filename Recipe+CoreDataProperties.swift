//
//  Recipe+CoreDataProperties.swift
//  MyRecipe
//
//  Created by horiuchi on 2023/01/30.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var procedure: String?
    @NSManaged public var category: String?
    @NSManaged public var ingredient: String?
    

}

extension Recipe : Identifiable {

}
