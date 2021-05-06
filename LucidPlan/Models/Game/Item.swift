//
//  Item.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 07.05.2021.
//

import Foundation

struct Item : Hashable{
    var title : String
    var description : String
    var price : Int
    var imageName : String
    var type : String // Heal, harm, energy
}
