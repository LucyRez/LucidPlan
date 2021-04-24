//
//  Habit+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 19.04.2021.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var title: String?
    @NSManaged public var points: Int64

}

extension Habit : Identifiable {

}
