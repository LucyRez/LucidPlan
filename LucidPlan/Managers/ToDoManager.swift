//
//  ToDoManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 15.04.2021.
//

import Foundation
import CoreData

/**
 This is to-do view manager.
 
 # What It Does: #
 1. Saves to-dos to CoreData
 2. Is used for adding new to-dos/editing existing to-dos
 
 */
class ToDoManager : ObservableObject, TaskManager{
    
    @Published var todo : ToDo! // Current todo.
    @Published var active : Bool = false // Shows if screen for adding/updating to-do can be shown.
    
    // Filter, which is used on the view
    // 0 represents daily to-do
    // 1 represents weekly to-do
    // 2 represents monthly to-do
    @Published var filter : Int = 0
    
    @Published var title : String = ""
    @Published var isCompleted : Bool = false
    @Published var tags : [String] = []
    
    // Type of to-do
    // 0 represents daily to-do
    // 1 represents weekly to-do
    // 2 represents monthly to-do
    @Published var type : Int = 0
    
    // Function is responsible for sawing data in CoreData
    func writeData(context: NSManagedObjectContext){
        // If todo is edited.
        if todo != nil {
            // Change all the properties of object according to input.
            todo.title = title
            todo.isCompleted = isCompleted
            todo.tags = tags
            todo.type = type
            
            try? context.save() // Trying to save current context.
            
            // Go back to default parameters.
            todo = nil
            active = false
            title = ""
            isCompleted = false
            tags = []
            type = 0
            
            return
        }
        
        // If new todo is created we are getting all the values from input.
        let newToDo = ToDo(context: context)
        newToDo.title = title
        newToDo.isCompleted = isCompleted
        newToDo.tags = tags
        newToDo.type = type
        
        try! context.save() // Trying to save current context.
        
        // Go back to default parameters.
        todo = nil
        active = false
        title = ""
        isCompleted = false
        tags = []
        type = 0
        
        return
    }
    
    // Function for triggering the editing of a to-do
    func editData(todo: ToDo){
        
        // If we want to edit todo, update all the fields of view with its parameters.

        self.todo = todo
        self.title = todo.title!
        self.isCompleted = todo.isCompleted
        self.tags = todo.tags!
        self.type = todo.type
        
        active = true // Edit view will be called.
    }
    
    // Function for adding tags to the to-do
    func addTag(tag: String){
        tags.append(tag)
    }
    
    // Function to delete to-do from CoreData
    func delete(context: NSManagedObjectContext, todo: ToDo){
        context.delete(todo)
        try! context.save()
    }
    
    // Function to update state of to-do (if it is finished or not)
    func updateState(todo: ToDo, context: NSManagedObjectContext){
        self.todo = todo
        if self.todo != nil {
            print("update \(todo.isCompleted)")
            self.title = todo.title!
            self.isCompleted = todo.isCompleted
            self.tags = todo.tags!
            self.type = todo.type
            
            try? context.save() // Trying to save current context.
            
            // Go back to default parameters.
            self.todo = nil
            active = false
            title = ""
            isCompleted = false
            tags = []
            type = 0
            
            return
        }
       
    }
}
