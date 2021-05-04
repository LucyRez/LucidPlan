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
        fetchRequest = FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: true)])
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.purple.ignoresSafeArea()
                
                if showSettings{
                    SettingsMenuView(settingsShow: $showSettings)
                }
                
                ZStack{
                   
                    Color.purple.opacity(0.8).ignoresSafeArea()
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
                        
                        CharacterView(manager: characterManager)
                            .padding(.top)
                        
                        HStack{
                            Button(action: {
                                // TODO: FILTER DEADLINES
                            },
                            label: {
                                Text("Filter")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            })
                            .padding()
                            
                            Spacer()
                            
                            Button(action: {
                                // TODO: ADD DEADLINES
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
                    
                }
                .cornerRadius(showSettings ? 20 : 0)
                .offset(x: showSettings ? 300 : 0, y: showSettings ? 40 : 0)
                .scaleEffect(showSettings ? 0.8 : 1)
                .navigationBarHidden(true)
                
            }
        }
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
