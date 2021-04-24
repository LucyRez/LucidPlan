//
//  CharacterManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 23.04.2021.
//

import Foundation
import CoreData
import SwiftUI

class CharacterManager: ObservableObject{
    @Environment(\.managedObjectContext) var context
    var character : Character
    
    init(){
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "character")
        
        do{
            let fetchRequest = try context.fetch(fetchRequest) as! [Character]
            
            if fetchRequest.count == 0 {
                let newCharacter = Character(context: context)
                newCharacter.exp = 0
                newCharacter.health = 100
                newCharacter.image = UIImage(systemName: "sparkle")
                try! context.save()
                character = newCharacter
            }else{
                character = fetchRequest.first!
                
            }
        }catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    
    func addToHealth(healthPoints: Int64){
        character.health+=healthPoints
        try! context.save()
    }
    
    func addToExp(expPoints: Int64){
        character.exp += expPoints
        try! context.save()
    }
    
    func getExp() -> Int64{
        return character.exp
    }
    
    func getHealth() -> Int64{
        return character.health
    }
}
