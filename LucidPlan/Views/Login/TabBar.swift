//
//  TabBar.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.04.2021.
//

import Foundation
import SwiftUI


struct TabBarView: View{
    @StateObject var socketManager : SocketIOManager = SocketIOManager() // Создаём сокет-менеджер.
    let tabBarImages : [String] = ["calendar","clock", "note.text", "person.2"]
    @State var viewIndex : Int = 0
    var body: some View{
        VStack{
            ZStack{
                switch viewIndex{
                case 0:
                    ScheduleView()
                case 1:
                    DeadlineView()
                case 2:
                    ToDoView()
                default:
                    ChatScreen(socketManager: socketManager)
                }
                
            }
            Spacer()
            
            HStack{
                ForEach(0..<4){number in
                    Button(action: {
                        viewIndex = number
                    }, label: {
                        Spacer()
                        Image(systemName: tabBarImages[number])
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black).opacity(viewIndex == number ? 1 : 0.3)
                        Spacer()
                    })
                    
                }
            }
        }
    }
}
