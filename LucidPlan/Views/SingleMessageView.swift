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
        VStack{
            HStack{
                // Располагаем сообщение по правому краю, если отправитель - текущий пользователь.
                if(isCurrentUser){
                    Spacer()
                }
                
                VStack{
                    // Для других пользователей устанавливаем их имена над текстом сообщений.
                    if(!isCurrentUser){
                        HStack{
                            Text(nickname)
                                .font(.system(size: 13))
                                .bold()
                                .offset(y:5)
                            Spacer()
                            
                        }
                    }
                    
                    // Цвет и расположение текста сообщения меняется в зависимости от статуса пользователя.
                    HStack{
                        Text(text)
                            .padding(10)
                            .foregroundColor(isCurrentUser ? Color.white : Color.black)
                            .background(isCurrentUser ? Color.blue : Color.gray)
                            .cornerRadius(10)
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
                if(!isCurrentUser){
                    Text(date, style: .time)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Spacer()
                    
                }else{
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
