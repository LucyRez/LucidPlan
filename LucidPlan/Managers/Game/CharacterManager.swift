//
//  CharacterManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 23.04.2021.
//

import Foundation
import CoreData
import SwiftUI

/**
 Class for managing playable character.

 # Notes: #
 1. <#Notes if any#>
 
 */
class CharacterManager: ObservableObject{
    var character : Character? // Current playable character.
    
    /**
     Function to initialize character.
     
     - parameter context: Current CoreData context.
   
     # Notes: #
     1. Creates character if it wasn't previously created.
     2. Otherwise the field in the class is initialized with Character object from storage.
     
     */
    func initializeCharacter(context: NSManagedObjectContext){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
        
        do{
            let fetchRequest = try context.fetch(fetchRequest) as! [Character]
            
            if fetchRequest.count != 0 {
                character = fetchRequest.first!
            }else{
                let newCharacter = Character(context: context)
                
                // Default values for character
                newCharacter.health = 100
                newCharacter.damage = 5
                newCharacter.name = "Default"
                newCharacter.maxEnergy = 100
                newCharacter.imageName = "sparkle"
                
                character = newCharacter
            }
             
        }catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    
    /**
     Function for adding/taking  away health points.
     
     - parameter healthPoints: Number of health points being added/taken.
     
     # Notes: #
     1. If the points are being added the number must be positive, otherwise negative.
     
     */
    func addToHealth(healthPoints: Int64, context: NSManagedObjectContext){
        if healthPoints > 0 {
            character!.health+=healthPoints
        }else{
            if character!.health > 10 {
                character!.health+=healthPoints
            }
        }
      
        try! context.save()
    }
    
    
    // Function returns current amount of health points
    func getHealth() -> Int64{
        return character!.health
    }
    
    func getImageName()->String{
        return character!.imageName ?? "sparkles"
    }
}
