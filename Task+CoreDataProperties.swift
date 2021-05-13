//
//  Task+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 13.05.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var note: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var tags: [String]?
    @NSManaged public var title: String?
    @NSManaged public var isDeadline: Bool

}

extension Task : Identifiable {

}
