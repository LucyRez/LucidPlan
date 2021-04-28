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
    @ObservedObject var todoManager : ToDoManager
    @ObservedObject var gameManager : GameManager
    @Environment(\.managedObjectContext) var context
    
    init(todo: ToDo, todoManager: ToDoManager, gameManager: GameManager){
        self.todoManager = todoManager
        self.gameManager = gameManager
        self.todo = todo
    }
    

    var body: some View{
        HStack(spacing:20){
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
            
            Text(todo.title ?? "")
                .font(.system(size: 22))
                .strikethrough(todo.isCompleted , color: Color.black)
            Spacer()
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
    }
    
    func updateGameStats(){
        if todo.isCompleted {
            gameManager.characterManager.addToExp(expPoints: 50, context: context)
        }else{
            gameManager.characterManager.addToExp(expPoints: -50, context: context)
        }
    }
}
