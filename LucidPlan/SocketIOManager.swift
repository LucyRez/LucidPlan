//
//  SocketIOManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import Foundation
import SocketIO

/**
 Этот класс реализует взаимодействие с сервером, используя вебсокеты.
 - returns: socket io manager
 */
final class SocketIOManager: ObservableObject{
    
    @Published var notJustOpened : Bool = false // Подключение уже было установлено.
    @Published var nickname : String = UserDefaults.standard.object(forKey: "nickname") as? String ?? "" // Имя пользователя-клиента.
    
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
            self.socket?.emit("Server Event", "Hi NODEJS server!") // Отправляем сообщение с кастомным ивентом на сервер.
        }
    }
    
    // Функция осуществляет отсоединение от сервера.
    func disconnect(){
        socket?.disconnect()
    }
    
    // Функция отправляет сообщение пользователя на сервер.
    func sendMessage(text: String, user: String){
        // Создаём объект сообщения.
        let message = SubmittedMessage(message: text, nickname: user )
        
        // Кодируем объект в JSON.
        guard let json = try? JSONEncoder().encode(message),
              let jsonString = String(data: json, encoding: .utf8)
        else{
            return
        }
        // Отправляем на сервер строку в формате JSON, тригерим ивент "chatMessage".
        socket?.emit("chatMessage", String(jsonString))
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

