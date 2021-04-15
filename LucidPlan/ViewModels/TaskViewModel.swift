//
//  TaskViewModel.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 24.03.2021.
//

import Foundation
import CoreData

class TaskViewModel : ObservableObject, TaskManager{
    
    @Published var task : Task! // Current task.
    @Published var active : Bool = false
    
    @Published var title : String = ""
    @Published var note : String = ""
    @Published var startDate : Date = Date()
    @Published var endDate : Date = Date() + 60*60
    @Published var status : String = ""
    @Published var tags : [String] = []
    @Published var date : Date = Date()
    
    func writeData(context: NSManagedObjectContext){
        // If task is edited.
        if task != nil {
            // Change all the properties of object according to input.
            task.title = title
            task.note = note
            task.startDate = startDate
            task.endDate = endDate
            task.status = status
            task.tags = tags
            
            try? context.save() // Trying to save current context.
            
            // Go back to default parameters.
            task = nil
            active = false
            title = ""
            note = ""
            startDate = Date()
            endDate = startDate + 60*60
            status = ""
            tags = []
            
            return
        }
        
        // If new task is created we are getting all the values from input.
        let newTask = Task(context: context)
        newTask.title = title
        newTask.note = note
        newTask.startDate = startDate
        newTask.endDate = endDate
        newTask.status = status
        newTask.tags = tags
        
        try! context.save() // Trying to save current context.
        
        // Go back to default parameters.
        task = nil
        active = false
        title = ""
        note = ""
        startDate = Date()
        endDate = startDate + 60*60
        status = ""
        tags = []
        
        return
    }
    
    
    func editData(task: Task){
        
        // If we want to edit task, update all the fields of view with its parameters.

        self.task = task
        self.title = task.title!
        self.note = task.note!
        self.startDate = task.startDate!
        self.endDate = task.endDate!
        self.status = task.status!
        self.tags = task.tags!
        
        active = true // Edit view will be called.
    }
    
    func addTag(tag: String){
        tags.append(tag)
    }
}
