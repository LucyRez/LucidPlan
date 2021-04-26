//
//  GameManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 23.04.2021.
//

import Foundation
import CoreData

/**
 This class manages all game process.

 # Notes: #
 1. <#Notes if any#>
 
 */
class GameManager: ObservableObject{
    
    var characterManager = CharacterManager() // Manager for controlling a character
    
    
    /**
      Function for initializing game manager (initializes character controller also).
     
     - parameter context: Current CoreData context.
     */
    func initializeGameManager(context: NSManagedObjectContext){
        characterManager.initializeCharacter(context: context)
    }
    
    
}
