//
//  ShopItem+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//
//

import Foundation
import CoreData


extension ShopItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopItem> {
        return NSFetchRequest<ShopItem>(entityName: "ShopItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var cost: Int64
    @NSManaged public var type: String? // Potion, character
    @NSManaged public var imageName: String?

}

extension ShopItem : Identifiable {

}
