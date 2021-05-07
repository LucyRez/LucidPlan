//
//  InventoryManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 07.05.2021.
//

import Foundation
import CoreData

class InventoryManager: ObservableObject{
    
    func delete(context: NSManagedObjectContext, item: ShopItem){
        context.delete(item)
        try! context.save()
    }
}
