//
//  ToDoManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 15.04.2021.
//

import Foundation
import CoreData

class ToDoManager : ObservableObject, TaskManager{
    
    @Published var todo : ToDo! // Current todo.
    @Published var active : Bool = false
    @Published var filter : Int = 0
    
    @Published var title : String = ""
    @Published var isCompleted : Bool = false
    @Published var tags : [String] = []
    @Published var type : Int = 0
    
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
    
    
    func editData(todo: ToDo){
        
        // If we want to edit todo, update all the fields of view with its parameters.

        self.todo = todo
        self.title = todo.title!
        self.isCompleted = todo.isCompleted
        self.tags = todo.tags!
        self.type = todo.type
        
        active = true // Edit view will be called.
    }
    
    func addTag(tag: String){
        tags.append(tag)
    }
    
    func delete(context: NSManagedObjectContext, todo: ToDo){
        context.delete(todo)
        try! context.save()
    }
    
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
