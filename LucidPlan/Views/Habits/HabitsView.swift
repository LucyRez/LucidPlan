//
//  HabitsView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 22.04.2021.
//

import SwiftUI

struct HabitsView: View {
    @StateObject var habitManager = HabitManager()
    @ObservedObject var gameManager : GameManager
    @State var showSettings : Bool = false
    @Environment(\.managedObjectContext) var context
    
    init(gameManager: GameManager){
        self.gameManager = gameManager
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.white.ignoresSafeArea()
                if showSettings{
                    SettingsMenuView(settingsShow: $showSettings, characterManager: gameManager.characterManager, userManager: gameManager.userManager)
                }
                ZStack{
                    Color.white.ignoresSafeArea()
                    VStack(alignment: .leading){
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
                                    .frame(width: 50, height: 50, alignment: .bottom)
                            })
                            
                            Spacer()
                        }.padding(.leading)
                        
                        Text("Трекер привычек")
                            .font(.title)
                            .bold()
                            .padding(20)
                        
                        
                        HabitsContainer(habitManager: habitManager, gameManager: gameManager)
                            .padding()
                        
                        HStack{
                            ZStack{
                                TextField("Добавить привычку...", text: $habitManager.titleForBinding)
                                    .font(.system(size: 20))
                                    .padding(.leading).zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                                
                                RoundedRectangle(cornerRadius: 22)
                                    .opacity(0.2)
                                    .frame(width: .infinity, height: 50)
                                    .zIndex(0)
                            }
                            
                            Button(action: {
                                habitManager.writeData(context: context)
                            }, label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                                    .font(.system(size: 35))
                                
                            })
                        }
                        .padding()
                        
                        Spacer()
                        
                    }
                    
                }
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
    }
}

struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView(gameManager: GameManager())
    }
}
