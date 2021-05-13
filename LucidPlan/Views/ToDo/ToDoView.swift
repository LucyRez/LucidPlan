//
//  ToDoView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.03.2021.
//

import SwiftUI

struct ToDoView: View {
    @State var showSettings : Bool = false
    @StateObject var todoManager = ToDoManager()
    @ObservedObject var gameManager : GameManager
    @State var tags : Set<String> = []
    @State var tagsNames : [String] = []
    //@State var filter = ""
    
    var fetchRequest : FetchRequest<ToDo>
    
    
    var todos : FetchedResults<ToDo>{
        fetchRequest.wrappedValue
    }
    
    init(gameManager: GameManager){
        self.gameManager = gameManager
        fetchRequest = FetchRequest(entity: ToDo.entity(), sortDescriptors: [])
    }
    
    func getTags(){
        for todo in todos {
            for tag in todo.tags ?? [] {
                if !tags.contains(tag) {
                    tags.insert(tag)
                    tagsNames.append(tag)
                }
            }
        }
    }
    
    
    var body: some View {
        
        ZStack{
            Color.white.ignoresSafeArea()
            
            if showSettings{
                SettingsMenuView(settingsShow: $showSettings, characterManager: gameManager.characterManager, userManager: gameManager.userManager)
            }
            
            VStack{
                
                HStack{
                    Button(action: {
                        withAnimation(.spring()){
                            showSettings.toggle()
                            
                        }
                    },
                    label: {
                        Text("...")
                            .bold()
                            .font(.system(size: 50))
                    })
                    .padding(.horizontal)
                    
                    TopToDoView(manager: todoManager).padding(.horizontal)
                }
                
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
                    
                    Menu{
                        Button(action: {todoManager.tag = ""},
                               label: {
                                HStack{
                                    Text("Без тега")
                                }
                                
                               })
                        
                        ForEach(tagsNames, id: \.self){tag in
                            Button(action: {todoManager.tag = tag},
                                   label: {
                                    HStack{
                                        Text(tag)
                                    }
                                    
                                   })
                        }
                       
                        
            
                    }
                    label: {
                        Text("Filter")
                            .font(.system(size: 25))
                            .padding()
                    }
                    .onAppear(perform: getTags)
                    
                   
                    
                }
                
                ToDoContainer(filter: todoManager.filter, todoManager: todoManager, gameManager: gameManager)
                
                Spacer()
                
            }
            .background(Color.white.ignoresSafeArea())
            .cornerRadius(showSettings ? 20 : 0)
            .offset(x: showSettings ? 300 : 0, y: showSettings ? 40 : 0)
            .scaleEffect(showSettings ? 0.8 : 1)
          
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
