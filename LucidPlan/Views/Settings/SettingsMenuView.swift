//
//  SettingsMenuView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 02.05.2021.
//

import SwiftUI

struct SettingsMenuView: View {
    @Environment(\.managedObjectContext) var context // Current context
    @Binding var settingsShow : Bool
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
                
                SettingsTopView()
                
                NavigationLink(
                    destination: Text("Game Statistics View"),
                    label: {
                        HStack(spacing: 16){
                            Image(systemName: "gamecontroller")
                                .frame(width: 24, height: 24)
                            
                            Text("Игровая статистика")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                    })
                
                NavigationLink(
                    destination: Text("Team View"),
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
                    destination: Text("Character Edit View"),
                    label: {
                        HStack(spacing: 16){
                            Image(systemName: "person.fill.viewfinder")
                                .frame(width: 24, height: 24)
                            
                            Text("Редактирование персонажа")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                    })
               
                
                NavigationLink(
                    destination: Text("Shop View"),
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
                    destination: CalendarImportView(context: context),
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
    var body: some View{
        VStack(alignment: .leading){
            Image(systemName: "sparkle")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(.yellow)
                .padding(.bottom, 15)
            
            Text("Lucy")
                .font(.system(size: 24, weight: .semibold))
            
        }
        .foregroundColor(.white)
        .padding()
    }
}
