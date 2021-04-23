//
//  HabitManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 19.04.2021.
//

import Foundation
import CoreData

/**
 This is habit view manager
 
 # What It Does: #
 1. Saves habits in CoreData
 2. Can be used to add new habits or edit them
 
 */
class HabitManager : ObservableObject{
    
    @Published var habit : Habit! // Current habit.
    
    @Published var title : String = ""
    @Published var titleForBinding = ""
    @Published var points : Int64 = 0
    
    
    // Function for writing data to CoreData
    func writeData(context: NSManagedObjectContext){
        // If habit is edited.
        if habit != nil {
            // Change all the properties of object according to input.
            habit.title = title
            habit.points = points
            
            try? context.save() // Trying to save current context.
            
            // Go back to default parameters.
            habit = nil
            title = ""
            points = 0
            
            return
        }
        
        // If new habit is created we are getting all the values from input.
        let newHabit = Habit(context: context)
        newHabit.title = titleForBinding
        newHabit.points = points
        
        try! context.save() // Trying to save current context.
        
        // Go back to default parameters.
        habit = nil
        title = ""
        titleForBinding = ""
        points = 0
        
        return
    }
    
    // Function for editing existing habit
    func editData(habit: Habit){
        
        // If we want to edit habit, update all the fields of view with its parameters.
        
        self.habit = habit
        self.title = habit.title!
        self.points = habit.points
        
    }
    
    func addPoints(context : NSManagedObjectContext, habit: Habit, numberOfPoints: Int64){
        self.habit = habit
        self.title = habit.title!
        self.points = habit.points
        
        // Change all the properties of object according to input.
        self.habit.title = habit.title
        self.habit.points = habit.points+numberOfPoints
        
        try? context.save() // Trying to save current context.
        
        // Go back to default parameters.
        self.habit = nil
        title = ""
        points = 0

    }
    
    func delete(context: NSManagedObjectContext, habit: Habit){
        context.delete(habit)
        try! context.save() 
    }
}


