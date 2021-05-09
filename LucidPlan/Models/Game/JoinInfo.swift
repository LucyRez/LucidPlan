//
//  JoinInfo.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 09.05.2021.
//

import Foundation


struct ReceivedJoinInfo: Decodable, Equatable{
    let message : String
    let success : Bool
}
