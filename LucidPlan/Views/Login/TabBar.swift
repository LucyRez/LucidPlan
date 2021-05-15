//
//  TabBar.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.04.2021.
//

import Foundation
import SwiftUI


struct TabBarView: View{
    @Environment(\.managedObjectContext) var context
    @StateObject var gameManager = GameManager()
    var nickname : String
    
    let tabBarImages : [String] = ["calendar","clock", "note.text", "face.smiling.fill"]
    let tabBarLabels : [String] = ["Календарь", "Дедлайны", "Задачи", "Привычки"]
    @State var viewIndex : Int = 0
    var body: some View{
        VStack{
            ZStack{
                switch viewIndex{
                case 0:
                    ScheduleView()
                case 1:
                    DeadlineViewWrapper(characterManager: gameManager.characterManager, userManager: gameManager.userManager)
                case 2:
                    ToDoView(gameManager: gameManager)
                default:
                    //ChatScreen(socketManager: socketManager)
                    HabitsView(gameManager: gameManager)
                    
                }
                
            }
            Spacer()
            
            HStack{
                ForEach(0..<4){number in
                    Button(action: {
                        viewIndex = number
                    }, label: {
                        Spacer()
                        VStack{
                            Image(systemName: tabBarImages[number])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black).opacity(viewIndex == number ? 1 : 0.3)
                            
                            Text(tabBarLabels[number])
                                .font(.system(size: 14))
                                .foregroundColor(.black).opacity(viewIndex == number ? 1 : 0.3)
                                
                        }
                        Spacer()
                    })
                    
                }
            }
            .padding(.bottom)
        }
        .onAppear(perform: {
            gameManager.initializeGameManager(context: context, nickname: nickname)
        })
    }
}

