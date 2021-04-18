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
    
    var fetchRequest : FetchRequest<ToDo>
    
    var todos : FetchedResults<ToDo>{
        fetchRequest.wrappedValue
    }
    
    
    init(filter: Int, manager: ToDoManager){
        todoManager = manager
        fetchRequest = FetchRequest(entity: ToDo.entity(), sortDescriptors: [], predicate:  NSPredicate(format: "type == %i", filter))
    }
    
    var body: some View{
        NavigationView{
            List{
                ForEach(todos){todo in
                    HStack{
                        SingleToDoView(todo: todo, manager: todoManager)
                        Spacer()
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
        
    }
}
