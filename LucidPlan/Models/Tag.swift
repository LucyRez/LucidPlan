//
//  Tag.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import Foundation


struct Tag : Identifiable {
    var text : String
    var id = UUID().uuidString
}
