//
//  SettingsMenuView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 02.05.2021.
//

import SwiftUI

struct SettingsMenuView: View {
    @Binding var settingsShow : Bool
    var body: some View {
        NavigationView{
            VStack{
                
                HStack(alignment: .top){
                    Spacer()
                    
                    Text("Settings")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.default){
                            settingsShow.toggle()}
                        
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.black)
                        
                    })
                    .padding(.vertical, 10)
                    
                }
                
                VStack(alignment:.leading){
                    NavigationLink(
                        destination: Text("Statistics view"),
                        label: {
                            Text("In-Game Statistics")
                                .foregroundColor(.black)
                                .font(.system(size: 22))
                        })
                        .padding()
                    
                    NavigationLink(
                        destination: Text("Import Calendars view"),
                        label: {
                            Text("Import Calendars")
                                .foregroundColor(.black)
                                .font(.system(size: 22))
                        })
                        .padding()
                    
                    NavigationLink(
                        destination: Text("Teams View"),
                        label: {
                            Text("See Your Team")
                                .foregroundColor(.black)
                                .font(.system(size: 22))
                        })
                        .padding()
                    
                    Spacer()
                }
                
                
                Spacer()
            }
           
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.width/1.5)
        .overlay(Rectangle().stroke().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .background(Color.white.opacity(settingsShow ? 1 : 0))
        .ignoresSafeArea()
        
        
    }
}

//struct SettingsMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsMenuView()
//    }
//}
