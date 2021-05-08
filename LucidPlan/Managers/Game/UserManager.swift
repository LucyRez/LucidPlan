//
//  UserManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 07.05.2021.
//

import Foundation
import CoreData

/**
 Class for managing user.
 */
class UserManager: ObservableObject{
    var user : User? // Current user.
    
    /**
     Function to initialize user.
     
     - parameter context: Current CoreData context.
   
     # Notes: #
     1. Creates user if it wasn't previously created.
     2. Otherwise the field in the class is initialized with User object from storage.
     
     */
    func initializeUser(context: NSManagedObjectContext, nickname : String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do{
            let fetchRequest = try context.fetch(fetchRequest) as! [User]
            
            if fetchRequest.count != 0 {
                user = fetchRequest.first!
            }else{
                let newUser = User(context: context)
                
                // Default values for user
                newUser.exp = 1
                newUser.coin = 100
                newUser.level = 1
                newUser.admin = false
                newUser.groupId = ""
                newUser.groupPoints = 0
                newUser.id = UUID()
                newUser.nickname = nickname
                
                user = newUser
            }
             
        }catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    
    
    // Function returns current amount of exp points
    func getExp() -> Int64{
        return user!.exp
    }
    
    func getCoins() -> Int64{
        return user!.coin
    }
    
    func getLevel() -> Int64{
        return user!.level
    }
    
    /**
     Function for adding/taking  away exp  points.
     
     - parameter expPoints: Number of exp points being added/taken.

     # Notes: #
     1. If the points are being added the number must be positive, otherwise negative.
     
     */
    func addToExp(expPoints: Int64, context: NSManagedObjectContext){
        if user!.exp + expPoints > 1000 {
            user!.level+=1
            user!.exp = (user!.exp + expPoints) - 1000
        }else{
            user!.exp += expPoints
            
        }
        try! context.save()
    }
    
    
    func addCoins(context: NSManagedObjectContext, amount: Int64){
        user!.coin+=amount
        
        try! context.save()
    }
}

