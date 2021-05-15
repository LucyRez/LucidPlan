//
//  SingleMessageView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import SwiftUI

struct SingleMessageView: View {
    
    var text : String // Текст сообщения.
    var nickname : String // Имя пользователя.
    var date : Date // Дата и время отправки.
    var isCurrentUser : Bool // Является ли отправитель текущим пользователем.
    
    // Инициализатор для сообщения.
    init(text: String, nickname: String, date: Date, isCurrentUser: Bool) {
        self.text = text
        self.date = date
        self.isCurrentUser = isCurrentUser
        self.nickname = nickname
    }
    
    var body: some View{
        VStack(alignment:.center){
            HStack(alignment:.center){
                // Располагаем сообщение по правому краю, если отправитель - текущий пользователь.
                if(isCurrentUser || nickname == "System"){
                    Spacer()
                }
                
                VStack(alignment:.center){
                    // Для других пользователей устанавливаем их имена над текстом сообщений.
                    if(!isCurrentUser && nickname != "System"){
                        HStack{
                            Text(nickname)
                                .font(.system(size: 13))
                                .bold()
                                .offset(y:5)
                                Spacer()
                        }
                    }
                    
                    // Цвет и расположение текста сообщения меняется в зависимости от статуса пользователя.
                    HStack(alignment:.center){
                        
                        Text(text)
                            .padding(10)
                            .foregroundColor(isCurrentUser || nickname == "System" ? Color.white : Color.black)
                            .background(isCurrentUser ? Color.blue : nickname == "System" ? Color.green.opacity(0.7) : Color.gray)
                            .cornerRadius(15)
                            .lineLimit(nil)
                        
                        if(!isCurrentUser){Spacer()}
                    }
                }.fixedSize(horizontal: false, vertical: true)
                
                // Располагаем сообщение по левому краю, если отправитель - не текущий пользователь.
                if(!isCurrentUser){
                    Spacer()
                }
            }
            
            // Отдельный стэк для того, чтобы расположить время отправки сообщения.
            HStack{
                if(!isCurrentUser && nickname != "System"){
                    Text(date, style: .time)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Spacer()
                    
                }else if nickname != "System"{
                    Spacer()
                    Text(date, style: .time)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
            }
        }.padding(10)
        
    }
}

//struct SingleMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleMessageView()
//    }
//}
