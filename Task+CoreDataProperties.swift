//
//  Task+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 24.03.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var note: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var tags: [String]?
    @NSManaged public var status: String?

}

extension Task : Identifiable {

}
