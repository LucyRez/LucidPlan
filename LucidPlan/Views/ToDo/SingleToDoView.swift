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
    @Environment(\.managedObjectContext) var context
    
    init(todo: ToDo, manager: ToDoManager){
        todoManager = manager
        self.todo = todo
    }
    
    var body: some View{
        HStack(spacing:20){
            Image(systemName: "checkmark.circle.fill")
            
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
        })
        .onLongPressGesture(perform: {
            todoManager.editData(todo: todo)
        })
    }
}
