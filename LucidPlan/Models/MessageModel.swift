//
//  MessageModel.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import Foundation

// Модель для отправляемых сообщений.
struct SubmittedMessage : Encodable{
    let message : String
    let nickname : String
}

// Модель для получаемых сообщений.
struct ReceivedMessage : Decodable, Equatable{
    let date : Date
    let id = UUID()
    let nickname : String
    let message : String
}
