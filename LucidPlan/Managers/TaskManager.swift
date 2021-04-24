//
//  TaskManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 15.04.2021.
//

import Foundation

// This protocol was created mostly to share the functionality between
// Task Manager and To Do Manager (for example adding tags)
protocol TaskManager {
    func addTag(tag:String)
}
