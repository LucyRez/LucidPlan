//
//  GameInfo.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 09.05.2021.
//

import Foundation

// Модель для отправляемых сообщений.
struct ReceivedGameInfo : Decodable, Equatable, Hashable{
    let _id : String
    let enemy : ReceivedEnemyInfo
    let messages : [String]
    let users : [ReceivedUserInfo]
}


struct ReceivedEnemyInfo: Decodable, Equatable, Hashable{
    let _id : String
    let damage : Int
    let health : Int
    let imageName : String
    let maxHealth : Int
}

struct SubmittedEnemyInfo: Encodable{
    let _id : String
    let damage : Int
    let health : Int
    let imageName : String
    let maxHealth : Int
}


struct DamageInfo: Encodable{
    let user : String
    let damage : Int
}
