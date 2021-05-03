//
//  DeadlineView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.03.2021.
//

import SwiftUI

struct DeadlineView: View {
    @State var showSettings : Bool = false
    @ObservedObject var characterManager : CharacterManager
    var fetchRequest : FetchRequest<Task>
    
    var tasks : FetchedResults<Task>{
        fetchRequest.wrappedValue
    }
    
    init(characterManager: CharacterManager){
        self.characterManager = characterManager
        fetchRequest = FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: false)])
    }
    
    var body: some View {
        ZStack(alignment:.leading){
            VStack{
                HStack{
                    Button(action: {
                        withAnimation(.default){
                            showSettings.toggle()
                            
                        }
                    },
                    label: {
                        Text("...")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 50))
                    })
                    .padding(.leading)
                    
                    Spacer()
                }
                
                CharacterView(manager: characterManager)
                
                HStack{
                    Button(action: {
                        
                    },
                    label: {
                        Text("Filter")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    })
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        
                    },
                    label: {
                        Text("Add")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
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
                                SingleDeadlineView(task: task)
                            }
                            
                        }
                        
                    }.zIndex(0.5)
                    
                }
                
            }
            .background(Color.purple.opacity(0.85))
            .ignoresSafeArea()
            
        }
        
        HStack{
            SettingsMenuView(settingsShow: $showSettings)
                .offset(x: self.showSettings ? 0 : -UIScreen.main.bounds.width/1.5)
                
            
            Spacer()
        }
        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
        
    }
}

struct SingleDeadlineView: View{
    
    var endTime : String
    var endDate : String
    var title : String
    
    
    init(task: Task){
        let endTime = Calendar.current.dateComponents([.hour, .minute], from: task.endDate!)
        let endDay = Calendar.current.dateComponents([.day,.month], from: task.startDate!)
        let end = "\(endTime.hour!):\(endTime.minute!)"
        let day = "\(endDay.day!).\(endDay.month!)"
        
        self.endTime = end
        self.endDate = day
        self.title = task.title!
        
    }
    var body: some View{
        HStack(alignment:.top, spacing:30){
            ZStack(alignment:.topLeading){
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color( red: 16/255, green: 230/255, blue: 162/255))
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
                    .fill(Color( red: 16/255, green: 230/255, blue: 162/255))
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

struct DeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        DeadlineView(characterManager: CharacterManager())
    }
}
