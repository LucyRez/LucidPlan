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
            Text("\(todoManager.todo != nil ? "Редактировать" : "Создать") задачу")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding()
            
            TextField("Введите название...", text: $todoManager.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            
            AddTagView(model: todoManager)
            
            Divider()
                .padding(.horizontal)
            
            HStack{
                TypeToDoButton(text: "День", manager: todoManager)
                TypeToDoButton(text: "Неделя", manager: todoManager)
                TypeToDoButton(text: "Месяц", manager: todoManager)
            }
            
            Button(action: {
                todoManager.writeData(context: context)
                
            }, label: {
                Label(
                    title: {
                        Text("\(todoManager.todo == nil ? "Добавить задачу" : "Изменить задачу")")
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

struct TypeToDoButton: View{
    @ObservedObject var toDoManager : ToDoManager
    var text : String
    
    init(text: String, manager: ToDoManager){
        self.text = text
        toDoManager = manager
    }
    
    
    func getType()->Int{
        switch(text){
        case "День":
            return 0
        case "Неделя":
            return 1
        case "Месяц":
            return 2
        default:
            return 0
        }
    }
    
    var body: some View{
        Button(action: {
            toDoManager.type = getType()
        }
        , label: {
            Text(text)
                .bold()
                .foregroundColor(getType() == toDoManager.type ? .white : .gray)
                .padding()
                .background(
                    getType() == toDoManager.type ?
                        LinearGradient(gradient: .init(colors: [Color(red: 121/255, green: 220/255, blue: 199/255), Color(red: 168/255, green: 226/255, blue: 201/255)]), startPoint: .leading, endPoint: .trailing)
                        :  LinearGradient(gradient: .init(colors: [Color(.white)]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(6)
        })
    }
}

struct AddToDo_Previews: PreviewProvider {
    static var previews: some View {
        AddToDo(todo: ToDoManager())
    }
}
