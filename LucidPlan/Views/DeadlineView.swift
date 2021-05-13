//
//  DeadlineView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.03.2021.
//

import SwiftUI

struct DeadlineViewWrapper : View{
    @ObservedObject var characterManager : CharacterManager
    @ObservedObject var userManager : UserManager
    @State var showEnded = false
    
    var body : some View{
        DeadlineView(characterManager: characterManager, userManager: userManager, showEnded: $showEnded)
    }
}
struct DeadlineView: View {
    @ObservedObject var model : TaskViewModel = TaskViewModel() // Task manager
    @State var showSettings : Bool = false
    @ObservedObject var characterManager : CharacterManager
    @ObservedObject var userManager : UserManager
    @Binding var showEnded : Bool
    @Environment(\.managedObjectContext) var context
    
    
    var fetchRequest : FetchRequest<Task>
    
    var tasks : FetchedResults<Task>{
        fetchRequest.wrappedValue
    }
    
    init(characterManager: CharacterManager, userManager: UserManager, showEnded : Binding<Bool>){
        self.characterManager = characterManager
        if showEnded.wrappedValue {
            self.userManager = userManager
            fetchRequest = FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: true)], predicate:
                                            NSPredicate(format: "isDeadline = %d && endDate < %@ ",true, Date() as NSDate))
        }else{
            self.userManager = userManager
            fetchRequest = FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: true)], predicate:
                                            NSPredicate(format: "isDeadline = %d && endDate >= %@ ",true, Date() as NSDate))
            
        }
        self._showEnded = showEnded
    }
    
    var body: some View {
        ZStack{
            Color.purple.ignoresSafeArea()
            
            if showSettings{
                SettingsMenuView(settingsShow: $showSettings, characterManager: characterManager, userManager: userManager)
            }
            
            
            
            VStack{
                HStack{
                    Button(action: {
                        withAnimation(.spring()){
                            showSettings.toggle()
                        }
                    },
                    label: {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 20))
                            .accentColor(.white)
                        
                    })
                    .padding(.leading, 15)
                    .padding(.top, 15)
                    Spacer()
                }
                
                CharacterView(characterManager: characterManager, userManager: userManager)
                
                HStack{
                    Menu{
                        
                        Button(action: {showEnded = false},
                               label: {
                                HStack{
                                    Text("Текущие дедлайны")
                                }
                                
                               })
                        
                        Button(action: {
                            showEnded = true
                            
                        }, label: {
                            HStack{
                                Text("Просроченные дедлайны")
                            }
                        })
                    }
                    label: {
                        Text("Filter")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    
                    
                    Spacer()
                    
                    Button(action: {
                        model.active.toggle()
                    },
                    label: {
                        Text("Add")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    })
                    .sheet(isPresented: $model.active, content: {
                        AddTaskView(task: model)
                    })
                    .padding()
                    
                }
                
                ZStack{
                    Rectangle()
                        .cornerRadius(radius: 25.0, corners: [.topLeft, .topRight])
                        .foregroundColor(.white)
                        .zIndex(0)
                    
                    ScrollView{
                        VStack{
                            ForEach(tasks){task in
                                Menu{
                                    Button(action: {
                                        model.delete(context: context, task: task)
                                        characterManager.addToHealth(healthPoints: 20, context: context)
                                    },
                                    label: {
                                        HStack{
                                            Text("Выполнено в срок")
                                            Image(systemName: "hand.thumbsup")
                                        }
                                        
                                    })
                                    
                                    Button(action: {
                                        model.delete(context: context, task: task)
                                        characterManager.addToHealth(healthPoints: -25, context: context)
                                        
                                    }, label: {
                                        HStack{
                                            Text("Просрочено")
                                            Image(systemName: "hand.thumbsdown")
                                        }
                                    })
                                }
                                label: {
                                    SingleDeadlineView(task: task)
                                }
                                
                            }
                            
                        }.zIndex(0.5)
                        
                    }
                    
                }
                
                
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [.purple, Color( red: 123/255, green: 75/255, blue: 235/255, opacity: 0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
            .cornerRadius(showSettings ? 20 : 0)
            .offset(x: showSettings ? 300 : 0, y: showSettings ? 40 : 0)
            .scaleEffect(showSettings ? 0.8 : 1)
            .navigationBarHidden(true)
            .onTapGesture {
                withAnimation(.spring()){
                    showSettings = false
                }
            }
        }
    }
    
    struct SingleDeadlineView: View{
        
        var endTime : String
        var endDate : String
        var title : String
        var difference : Int
        
        init(task: Task){
            let endTime = Calendar.current.dateComponents([.hour, .minute], from: task.endDate!)
            let endDay = Calendar.current.dateComponents([.day,.month], from: task.startDate!)
            let end = "\(endTime.hour!):\(endTime.minute!)"
            var day = "\(endDay.day!).\(endDay.month!)"
            if(endDay.month! < 10){
                day = "\(endDay.day!).0\(endDay.month!)"
            }
            
            let number = Calendar.current.dateComponents([.day], from: Date() , to: task.endDate!)
            difference = number.day!
            
            self.endTime = end
            self.endDate = day
            self.title = task.title!
            
        }
        
        var body: some View{
            HStack(alignment:.top, spacing:30){
                ZStack(alignment:.topLeading){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(difference <= 3 ? Color( red: 255/255, green: 100/255, blue: 84/255) : (difference <= 7 ? Color( red: 255/255, green: 151/255, blue: 60/255)  : Color( red: 80/255, green: 167/255, blue: 104/255)))
                        .frame(width: 100, height: 100)
                    
                    VStack{
                        HStack{
                            Text(endDate)
                                .bold()
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                                .padding(.top)
                                .padding(.horizontal)
                            
                        }
                        
                        Text(endTime)
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.horizontal)
                        
                    }
                    
                }
                
                ZStack(alignment:.topLeading){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(difference <= 3 ? Color( red: 255/255, green: 100/255, blue: 84/255) : (difference <= 7 ? Color( red: 255/255, green: 151/255, blue: 60/255)  : Color( red: 80/255, green: 167/255, blue: 104/255)) )
                        .frame(width: .infinity, height: 100)
                    HStack{
                        Text(title)
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding()
                        
                    }
                    
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
    
}
