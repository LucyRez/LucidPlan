//
//  Character+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 23.04.2021.
//
//

import Foundation
import SwiftUI
import CoreData


extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var health: Int64
    @NSManaged public var exp: Int64
    @NSManaged public var level: Int64
    @NSManaged public var image: UIImage?

}

extension Character : Identifiable {

}
