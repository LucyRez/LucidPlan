//
//  ToDoView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.03.2021.
//

import SwiftUI

struct ToDoView: View {
    @StateObject var todoManager = ToDoManager()
    @ObservedObject var gameManager : GameManager
    
    init(gameManager: GameManager){
        self.gameManager = gameManager
    }
    
    var body: some View {
        VStack{
            TopToDoView(manager: todoManager).padding(.horizontal)
            
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
            
            ToDoContainer(filter: todoManager.filter, todoManager: todoManager, gameManager: gameManager)
            
            Spacer()
            
        }
        
    }
}



struct TopToDoView: View{
    @ObservedObject var todoManager : ToDoManager
    
    init(manager: ToDoManager){
        todoManager = manager
    }
    
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
                    todoManager.filter = 0
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
                    todoManager.filter = 1
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
                    todoManager.filter = 2
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

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView(gameManager: GameManager())
    }
}
