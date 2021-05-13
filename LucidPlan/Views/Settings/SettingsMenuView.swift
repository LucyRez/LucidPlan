//
//  SettingsMenuView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 02.05.2021.
//

import SwiftUI

struct SettingsMenuView: View {
    @Binding var settingsShow : Bool
    @ObservedObject var characterManager : CharacterManager
    @ObservedObject var userManager : UserManager
    
 
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Button(action: {
                withAnimation(.spring()){
                    settingsShow.toggle()
                }
            }, label: {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
            })
            
            VStack(alignment:.leading){
                
                SettingsTopView(userManager: userManager)
                
                NavigationLink(
                    destination: FightView(characterManager: characterManager, userManager: userManager),
                    label: {
                        HStack(spacing: 16){
                            Image(systemName: "gamecontroller")
                                .frame(width: 24, height: 24)
                            
                            Text("Битва")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                    })
                
                NavigationLink(
                    destination: TeamView(userManager: userManager, characterManager: characterManager),
                    label: {
                        HStack(spacing: 16){
                            Image(systemName: "person.3")
                                .frame(width: 24, height: 24)
                            
                            Text("Команда")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                    })
                
                
                NavigationLink(
                    destination: Inventory(characterManager: characterManager),
                    label: {
                        HStack(spacing: 16){
                            Image(systemName: "person.fill.viewfinder")
                                .frame(width: 24, height: 24)
                            
                            Text("Инвентарь")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                    })
               
                
                NavigationLink(
                    destination: ShopView( userManager: userManager),
                    label: {
                        HStack(spacing: 16){
                            Image(systemName: "dollarsign.square")
                                .frame(width: 24, height: 24)
                            
                            Text("Магазин")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                    })
               
                
                NavigationLink(
                    destination: CalendarImportView(),
                    label: {
                        HStack(spacing: 16){
                            Image(systemName: "icloud.and.arrow.down")
                                .frame(width: 24, height: 24)
                            
                            Text("Импорт календарей")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                    })
                
                
                Spacer()
            }
            .navigationBarHidden(true)
           
        }
    }
}

struct SettingsTopView: View{
    var userManager: UserManager
    var body: some View{
        VStack(alignment: .leading){
            Image(systemName: "sparkle")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(.yellow)
                .padding(.bottom, 15)
            
            Text(userManager.user!.nickname ?? "")
                .font(.system(size: 24, weight: .semibold))
            
        }
        .foregroundColor(.white)
        .padding()
    }
}
