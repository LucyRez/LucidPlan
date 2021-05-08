//
//  Character+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 06.05.2021.
//
//

import Foundation
import CoreData


extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var health: Int64
    @NSManaged public var imageName: String?
    @NSManaged public var maxEnergy: Int64
    @NSManaged public var damage: Int64
    @NSManaged public var name: String?

}

extension Character : Identifiable {

}
