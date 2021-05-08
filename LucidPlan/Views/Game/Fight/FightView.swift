//
//  FightView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct FightView: View {
    @ObservedObject var characterManager : CharacterManager
    @ObservedObject var userManager : UserManager
  
    var image : UIImage = UIImage(systemName: "sparkle") ?? UIImage()
    
    var body: some View {
        HStack{
            Spacer()
        VStack{
            Spacer()
            VStack(spacing:-40){
                ZStack{
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    Image(systemName: "sparkle")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.yellow)
                }
                
            
                
                Button(action: {
                    // TODO: FIGHT MENU
                },
                label: {
                    ZStack(alignment: .trailing){
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 130, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                        
                        Text("Fight")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                    }
                })
            }
            
            ZStack{
                Rectangle()
                    .cornerRadius(radius: 20, corners: [.bottomLeft, .topRight, .topLeft])
                    .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/3.4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                VStack(alignment:.leading){
                    Text("Lvl. \(userManager.getLevel())")
                    Text("Health \(characterManager.getHealth()) / 100")
                    Text("Experience \(userManager.getExp()) / 1000")
                    Text("Gold \(userManager.getCoins())")
                }
                .foregroundColor(.white)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
            }
            .padding()
            
            
            BottomButtons()
            Spacer()
             
            
        }
            Spacer()
        }
        .background(Color.blue.opacity(0.1))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
    
}

struct BottomButtons: View{
    var body: some View{
        HStack(spacing:20){
            Button(action: {
                
            },
            label: {
                Image(systemName: "sparkle")
                    .resizable()
                    .frame(width: 40, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.black)
                    .padding(.leading, 2)
                    .padding(.top, 9)
                    .padding(.bottom, 9)
                
                
                Text("INVENTORY")
                    .bold()
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .padding(.trailing,2)
            })
            .background(Color(red: 255/255, green: 204/255, blue: 77/255))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: {
                // TODO: SHOP VIEW
            },
            label: {
                Image(systemName: "sparkle")
                    .resizable()
                    .frame(width: 40, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.black)
                    .padding(.leading)
                    .padding(.top, 9)
                    .padding(.bottom, 9)
                
                
                Text("SHOP")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .padding(.trailing)
            })
            .background(Color(red: 255/255, green: 204/255, blue: 77/255))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

