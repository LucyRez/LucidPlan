//
//  GameInfo.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 09.05.2021.
//

import Foundation

// Модель для отправляемых сообщений.
struct ReceivedGameInfo : Decodable, Equatable{
    let _id : String
    let enemy : ReceivedEnemyInfo
    let messages : [String]
    let users : [ReceivedUserInfo]
}


struct ReceivedEnemyInfo: Decodable, Equatable{
    let _id : String
    let damage : Int
    let health : Int
    let imageName : String
    let maxHealth : Int
}
