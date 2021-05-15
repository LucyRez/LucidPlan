//
//  SingleToDoView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.04.2021.
//

import Foundation
import SwiftUI

struct SingleToDoView: View{
    var todo: ToDo
    var text : String?
    @StateObject var gameNetwork = GameNetworkManager()
    @ObservedObject var todoManager : ToDoManager
    @ObservedObject var gameManager : GameManager
    @Environment(\.managedObjectContext) var context
    
    init(todo: ToDo, todoManager: ToDoManager, gameManager: GameManager){
        self.todoManager = todoManager
        self.gameManager = gameManager
        self.todo = todo
    }
    

    var body: some View{
        VStack(alignment:.leading){
        HStack(spacing:20){
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
            
            Text(todo.title ?? "")
                .font(.system(size: 22))
                .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                .strikethrough(todo.isCompleted , color: Color.black)
            Spacer()
        }
            HStack{
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle").opacity(0)
            ForEach(todo.tags ?? [], id: \.self){tag in
                Text(tag)
                    .foregroundColor(Color( red: 51/255, green: 51/255, blue: 51/255))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Capsule().fill(Color( red: 202/255, green: 255/255, blue: 191/255)))
            }
                
            }
            .padding(.vertical,5)
        }
        .padding(.trailing)
        .padding(.vertical)
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            todo.isCompleted.toggle()
            todoManager.updateState(todo: todo, context: context)
            updateGameStats()
        })
        .onLongPressGesture(perform: {
            todoManager.editData(todo: todo)
        })
        .onAppear(perform: gameNetwork.setSocket)
        .onDisappear(perform: gameNetwork.disconnect)
    }
    
    func updateGameStats(){
        if todo.isCompleted {
            gameManager.userManager.addToExp(expPoints: 50, context: context)
            gameNetwork.takeDamage(damage: DamageInfo(_id: gameManager.userManager.user!.groupId!, damage: 15, message:
                                                        SubmittedMessage(message: "Пользователь \(gameManager.userManager.user!.nickname!) выполнил задачу и нанёс ротивнику 15 ед. урона", nickname: "System")))
        }else{
            gameManager.userManager.addToExp(expPoints: -50, context: context)
        }
    }
}


