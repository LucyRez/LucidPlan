//
//  Enemy+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 06.05.2021.
//
//

import Foundation
import CoreData


extension Enemy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Enemy> {
        return NSFetchRequest<Enemy>(entityName: "Enemy")
    }

    @NSManaged public var damage: Int64
    @NSManaged public var hp: Int64
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var critPercent: Int64

}

extension Enemy : Identifiable {

}
