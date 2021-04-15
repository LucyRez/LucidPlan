//
//  ToDoView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.03.2021.
//

import SwiftUI

struct ToDoView: View {
    @StateObject var todoManager = ToDoManager()
    var body: some View {
        VStack{
            TopToDoView().padding(.horizontal)
            
            HStack{
                
                Button(action: {todoManager.active.toggle()}, label: {
                    Text("Add")
                        .font(.system(size: 25))
                })
                .sheet(isPresented: $todoManager.active, content: {
                    AddToDo(todo: todoManager)
                })
                .padding()
                
                Spacer()
                
                Button(action: {
                    
                },
                label: {
                    Text("Filter")
                        .font(.system(size: 25))
                })
                .padding()
                
                
                
            }
            
            ToDoContainer(filter: "")
            
            Spacer()
            
        }
        
    }
}

struct ToDoContainer: View{
    
    var fetchRequest : FetchRequest<ToDo>
    
    var todos : FetchedResults<ToDo>{
        fetchRequest.wrappedValue
    }
    
    
    init(filter: String){
        fetchRequest = FetchRequest(entity: ToDo.entity(), sortDescriptors: [])
    }
    
    var body: some View{
        List{
            ForEach(todos){todo in
                SingleToDoView(text: todo.title ?? "")
            }
        }
    }
}

struct TopToDoView: View{
    var body: some View{
        HStack(alignment:.bottom){
            Button(action: {
                // TODO экран настроек
            },
            label: {
                Text("...")
                    .bold()
                    .font(.system(size: 50))
            })
            
            
            Spacer()
            
            HStack(spacing: -10){
                
                Button(action: {
                    // TODO экран с отображением на неделю
                },
                label: {
                    Text(" День ")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 11)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .font(.system(size: 18))
                }).zIndex(1)
                
                Button(action: {
                    // TODO экран с отображением на неделю
                },
                label: {
                    Text("Неделя")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 11)
                        .padding(.horizontal, 18)
                        .background(Color(red: 56/255, green: 159/255, blue: 255/255))
                        .font(.system(size: 18))
                }).zIndex(1)
                
                
                Button(action: {
                    // TODO с отображением на месяц
                },
                label: {
                    Text("Месяц")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 11)
                        .padding(.leading, 20)
                        .padding(.trailing, 15)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .font(.system(size: 18))
                }).zIndex(0)
                
            }
            
        }
    }
}

struct SingleToDoView: View{
    var text : String
    @State var isDone : Bool = false
    
    init(text: String){
        self.text = text
    }
    
    var body: some View{
        HStack(spacing:20){
            Button(action: {isDone.toggle()}, label: {
                Image(systemName: "checkmark.circle.fill")
            })
            Text(text)
                .font(.system(size: 22))
                .strikethrough(isDone, color: /*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        }
        .padding(.trailing)
        .padding(.vertical)
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
