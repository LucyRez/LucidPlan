//
//  AddToDo.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 15.04.2021.
//

import SwiftUI

struct AddToDo: View {
    @ObservedObject var todoManager : ToDoManager
    @Environment(\.managedObjectContext) var context
    
    
    init(todo:ToDoManager){
        UITextView.appearance().backgroundColor = .clear
        self.todoManager = todo
    }
    
    var body: some View{
        
        VStack{
            Text("\(todoManager.todo != nil ? "Update" : "Create New") ToDo")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding()
            
            TextField("Enter the title", text: $todoManager.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            
            AddTagView(model: todoManager)
            
            Divider()
                .padding(.horizontal)
            
            
            Button(action: {
                todoManager.writeData(context: context)
                
            }, label: {
                Label(
                    title: {
                        Text("\(todoManager.todo == nil ? "Add ToDo" : "Edit ToDo")")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                        
                    },
                    icon: {
                        Image(systemName: "\(todoManager.todo == nil ? "plus" : "")")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                    })
                    .frame(width: UIScreen.main.bounds.width-30)
                    .padding(.vertical)
                    .background(
                        LinearGradient(gradient: .init(colors: [Color(red: 121/255, green: 220/255, blue: 199/255), Color(red: 168/255, green: 226/255, blue: 201/255)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(8)
            })
            .padding()
            .disabled(todoManager.title == "")
            
        }
        .padding()
        .onDisappear(perform: {
            todoManager.todo = nil
            todoManager.title = ""
        })
        
        
    }
    
}

struct AddToDo_Previews: PreviewProvider {
    static var previews: some View {
        AddToDo(todo: ToDoManager())
    }
}
