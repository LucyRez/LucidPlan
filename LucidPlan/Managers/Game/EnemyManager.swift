//
//  EnemyManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 05.05.2021.
//

import Foundation
import CoreData

class EnemyManager: ObservableObject{
    var enemy : Enemy?
    let enemyNames : KeyValuePairs = ["Dreamon" : "Earth", "Blitz" : "Fire", "Frosty" : "Water", "Corvus" : "Air"]
    var isDead : Bool = false
    
    func initializeEnemy(context: NSManagedObjectContext){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Enemy")
        
        do{
            let fetchRequest = try context.fetch(fetchRequest) as! [Enemy]
            
            if fetchRequest.count != 0 {
                enemy = fetchRequest.first!
            }else{
                let newEnemy = Enemy(context: context)
                let randNumber = Int.random(in: 0...3)
                // Default values for character
                newEnemy.hp = 100
                newEnemy.damage = 10
                newEnemy.name = enemyNames[randNumber].key
                newEnemy.type = enemyNames[randNumber].value
                newEnemy.imageName = ""
                
                enemy = newEnemy
                
                try! context.save()
            }
            
        }catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    
    func addToHealth(healthPoints: Int64, context: NSManagedObjectContext){
        if healthPoints > 0 {
            enemy!.hp+=healthPoints
        }else{
            if enemy!.hp > 10 {
                enemy!.hp+=healthPoints
            }else{
                isDead = true
                context.delete(enemy!)
            }
        }
        
        try! context.save()
    }
    
    // Function returns current amount of health points
    func getHealth() -> Int64{
        return isDead ? 0 : enemy!.hp
    }
    
    
}
