//
//  UserInfo.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 09.05.2021.
//

import Foundation

// Модель для отправляемых сообщений.
struct SubmittedUserInfo : Encodable{
    let groupId : String
    let nickname : String
    let level : Int
    let points : Int
    let hp : Int
    let imageName : String
}

// Модель для отправляемых сообщений.
struct ReceivedUserInfo : Decodable, Equatable, Hashable{
    let groupId : String
    let nickname : String
    let level : Int
    let points : Int
    let hp : Int
    let imageName : String
}
