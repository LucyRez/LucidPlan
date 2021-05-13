//
//  ToDoContainerView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.04.2021.
//

import Foundation
import SwiftUI


struct ToDoContainer: View{
    @Environment(\.managedObjectContext) var context
    @ObservedObject var todoManager : ToDoManager
    @ObservedObject var gameManager : GameManager
    
    
    var fetchRequest : FetchRequest<ToDo>
    
    var todos : FetchedResults<ToDo>{
        fetchRequest.wrappedValue
    }
    
    
    init(filter: Int, todoManager: ToDoManager, gameManager: GameManager){
        self.todoManager = todoManager
        self.gameManager = gameManager
        fetchRequest = FetchRequest(entity: ToDo.entity(), sortDescriptors: [], predicate:  NSPredicate(format: "type == %i", filter))
        
    }
    
    
    
    var body: some View{
        
        NavigationView{
            List{
                ForEach(todos){(todo:ToDo) in
                    
                    if todoManager.tag != "" && ((todo.tags!.contains(todoManager.tag))) {
                        HStack{
                            SingleToDoView(todo: todo, todoManager: todoManager, gameManager: gameManager)
                            
                            
                            Spacer()}
                        
                    }else if todoManager.tag == ""{
                        HStack{
                            SingleToDoView(todo: todo, todoManager: todoManager, gameManager: gameManager)
                            Spacer()
                            
                        }
                    }
                    
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet{
                        let todo = todos[index]
                        todoManager.delete(context: context, todo: todo)
                    }
                    
                })
                
                
            }
            .toolbar(content: {
                EditButton()
            })
            
        }
        .sheet(isPresented: $todoManager.active, content: {
            AddToDo(todo: todoManager)
        })
        .onAppear()
        
    }
    
    
}
