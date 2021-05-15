//
//  GameNetworkManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 08.05.2021.
//

import Foundation
import SocketIO

/**
 Этот класс реализует взаимодействие с сервером, используя вебсокеты.
 - returns: socket io manager
 */
final class GameNetworkManager: ObservableObject{
    
    // Сокет-менеджер слушает определённый порт на локальном сервере.
    private var manager = SocketManager(socketURL: URL(string: "ws://localhost:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient? = nil // Здесь будет храниться сокет клиента.
    
    // Функция инициализирует вебсокет и устанавливает все ивенты.
    func setSocket(){
        self.socket = manager.defaultSocket
        socket?.connect() // Подключаемся к серверу.
        setSocketEvents() // Устанавливаем ивенты.
    }
    
    // Содержимое функции срабатывает при подключении к серверу (нужно в тестовых целях).
    func setSocketEvents(){
        socket?.on(clientEvent: .connect){ (data,ack) in
            print("Connected")
            self.socket?.emit("test", "Hi NODEJS server!") // Отправляем сообщение с кастомным ивентом на сервер.
        }
        
        socket?.on("joined"){data, ack in
           print(data)
        }
        
        socket?.on("roomCreated"){data, ack in
           print(data)
        }
        
        socket?.on("message"){data, ack in
            print(data)
        }
        
    }
    
    func takeDamage(damage: DamageInfo){
        let tookDamage = damage
        guard let json = try? JSONEncoder().encode(tookDamage),
              let jsonString = String(data: json, encoding: .utf8)
        else{
            return
        }
        socket?.emit("takeDamage", jsonString);
    }
    
    // For creating new room
    func sendCode(code : String, userManager: UserManager, hp: Int, imageName: String){
        let userInfo = SubmittedUserInfo(groupId: code, nickname: userManager.user!.nickname!, level: Int(userManager.getLevel()),
                                         points: Int(userManager.getExp()), hp: hp, imageName: imageName)
        // Кодируем объект в JSON.
        guard let json = try? JSONEncoder().encode(userInfo),
              let jsonString = String(data: json, encoding: .utf8)
        else{
            return
        }
        socket?.emit("createRoom", jsonString)
    }
    
    
    // For checking room code
    func checkCode(code : String, userManager: UserManager, hp: Int, imageName: String){
        let userInfo = SubmittedUserInfo(groupId: code, nickname: userManager.user!.nickname!, level: Int(userManager.getLevel()),
                                         points: Int(userManager.getExp()), hp: hp, imageName: imageName)
        // Кодируем объект в JSON.
        guard let json = try? JSONEncoder().encode(userInfo),
              let jsonString = String(data: json, encoding: .utf8)
        else{
            return
        }
        socket?.emit("join", jsonString)
    }
    
    func askForGame(id: String){
        socket?.emit("oldUser", id)
    }
    
    // Получаем одно присланное сообщение.
    func getGame(completionHandler: @escaping (ReceivedGameInfo) -> Void){
        var game : ReceivedGameInfo?
        
        // Сервер должен прислать данные ивенту "getGame".
        socket?.on("getGame"){data, ack in
            
            if let jsonData  = try? JSONSerialization.data(withJSONObject: data.first!, options: []){
                do{
                    let decoder = JSONDecoder()
                                   
                    game = try! decoder.decode(ReceivedGameInfo.self, from: jsonData) // Декодируем сообщение.
                }
            }
            //Возвращаем полученное декодированное сообщение.
            completionHandler(game!)
        }
    }
    
    // Получаем одно присланное сообщение.
    func getCode(completionHandler: @escaping (ReceivedJoinInfo) -> Void){
        var groupExist : ReceivedJoinInfo?
        
        // Сервер должен прислать данные ивенту "getGame".
        socket?.on("getCode"){data, ack in
            
            if let jsonData  = try? JSONSerialization.data(withJSONObject: data.first!, options: []){
                do{
                    let decoder = JSONDecoder()
                                   
                    groupExist = try! decoder.decode(ReceivedJoinInfo.self, from: jsonData) // Декодируем сообщение.
                }
            }
            //Возвращаем полученное декодированное сообщение.
            completionHandler(groupExist!)
        }
    }

    
    // Функция осуществляет отсоединение от сервера.
    func disconnect(){
        socket?.disconnect()
    }
    
    
    // Функция осуществляет получение всей истории сообщений с базы данных на сервере.
    func getMessages(completionHandler: @escaping ([ReceivedMessage]) -> Void){
        var messages : [ReceivedMessage] = [] // Массив полученных сообщений.
        
        // Сервер должен прислать данные ивенту "messageHistory".
        socket?.on("messageHistory"){data, ack in
            
            // Декодируем полученный JSON в объект сообщения.
            if let jsonData  = try? JSONSerialization.data(withJSONObject: data.first!, options: []){
                do{
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    
                    // Далее следует код для парсинга даты и времени.
                    formatter.calendar = Calendar(identifier: .iso8601)
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    // Делаем кастомный декодер для даты.
                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateStr = try container.decode(String.self)
                        
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        return Date()
                    })
                    
                    messages = try! decoder.decode([ReceivedMessage].self, from: jsonData) // Декодируем массив объектов.
                }
            }
            // Возвращаем массив сообщений.
            completionHandler(messages)
        }
    }
    
    // Получаем одно присланное сообщение.
    func getLastMessage(completionHandler: @escaping (ReceivedMessage) -> Void){
        var message : ReceivedMessage?
        
        // Сервер должен прислать данные ивенту "newMessage".
        socket?.on("newMessage"){data, ack in
            
            if let jsonData  = try? JSONSerialization.data(withJSONObject: data.first!, options: []){
                do{
                    let decoder = JSONDecoder()
                    
                    let formatter = DateFormatter()
                    formatter.calendar = Calendar(identifier: .iso8601)
                    // Далее следует код для парсинга даты и времени.
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    // Делаем кастомный декодер для даты.
                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateStr = try container.decode(String.self)
                        
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        return Date()
                    })
                    
                    message = try! decoder.decode(ReceivedMessage.self, from: jsonData) // Декодируем сообщение.
                }
            }
            //Возвращаем полученное декодированное сообщение.
            completionHandler(message!)
        }
    }
}

