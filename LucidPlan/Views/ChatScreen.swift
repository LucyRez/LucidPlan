//
//  ChatScreen.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import SwiftUI

struct ChatScreen: View {
    @State private var message = "" // Сообщение из текстового поля.
    private var manager : SocketIOManager // socket io менеджер.
    
    // Массив полученных сообщений.
    @State private var messages: [ReceivedMessage] = []
    
    // Функция подключает чат к вебсокетам при запуске чата.
    func onAppear(){
        manager.setSocket()
    }
    
    // Функция отключает приложение от сервера при закрытии.
    func onDisappear(){
        manager.disconnect()
    }
    
    // Функция инициализирует отправку сообщения на сервер.
    private func onSend(){
        if !message.isEmpty {
            manager.sendMessage(text: message, user: manager.nickname)
            message = ""
        }
    }
    
    // Функция отвечает за получение сообщений клиентом при запуске и далее.
    func startGettingMessages(){
        // При запуске получаем всю историю сообщений.
        manager.getMessages(completionHandler: {data in
            messages = data
        })
        
        // Далее получаем сообщения по одному.
        manager.getLastMessage(completionHandler: {data in
            messages.append(data)
        })
    }
    
    // Инициализатор для текущего экрана.
    init(socketManager : SocketIOManager) {
        self.manager = socketManager // Сокет-менеджер полученный от стартового экрана.
    }
    
    var body: some View {
        VStack{
            // Здесь отображаются все сообщения.
            ScrollView{
                ScrollViewReader{val in
                    VStack{
                        
                        ForEach(messages, id: \.id){mes in
                            HStack{
                                SingleMessageView(text: mes.message, nickname: mes.nickname, date: mes.date, isCurrentUser: (mes.nickname == manager.nickname))
                                
                            }.id(mes.id)
                            
                        }
                        
                    }.onChange(of: messages, perform: {value in
                        DispatchQueue.main.async {
                            val.scrollTo(messages[messages.endIndex-1].id, anchor: .bottom) // Авто скролл к концу массива сообщений.
                        }
                    });
                }
            }
            
            // HStack содержит UI элементы отвечающие за отправку сообщения (текстовое поле и кнопка).
            HStack{
                
                TextField("Message", text: $message)
                    .padding(10)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(5.0)
                
                Button(action: onSend) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 25))
                }
                .padding(5)
                .disabled(message.isEmpty)
            }
            .padding()
            
        }
        .onAppear(perform: onAppear) // При появлении экрана чата подключаемся к серверу.
        .onAppear(perform: startGettingMessages) // Начинаем получать все сообщения.
        .onDisappear(perform: onDisappear) // При выходе отключаемcя от сервера.
        .padding()
    }
}

