//
//  User+CoreDataProperties.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 07.05.2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var coin: Int64
    @NSManaged public var groupId: String?
    @NSManaged public var exp: Int64
    @NSManaged public var level: Int64
    @NSManaged public var groupPoints: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var admin: Bool
    @NSManaged public var nickname: String?
    @NSManaged public var energy: Int64
}

extension User : Identifiable {

}
