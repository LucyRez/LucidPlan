//
//  ToDo+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 15.04.2021.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var tags: [String]?
    @NSManaged public var type: Int

}

extension ToDo : Identifiable {

}
