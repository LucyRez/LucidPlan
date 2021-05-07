//
//  ShopManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 07.05.2021.
//

import Foundation

import CoreData

class ShopManager: ObservableObject{
    // Function for writing data to CoreData
    func writeData(context: NSManagedObjectContext, boughtItem: Item){
        
        // If new item is being added we are getting all the values from input.
        let newItem = ShopItem(context: context)
        newItem.cost = Int64(boughtItem.price)
        newItem.imageName = boughtItem.imageName
        newItem.title = boughtItem.title
        newItem.type = boughtItem.type
        
        try! context.save() // Trying to save current context.
        
        return
    }
 
}
