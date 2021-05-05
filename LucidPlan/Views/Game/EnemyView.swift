//
//  EnemyView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct EnemyView: View {
    @State var characterEnergy = 100
    
    var body: some View {
        ZStack{
            Color.blue.opacity(0.2).ignoresSafeArea()
            VStack{
                HStack(alignment:.top){
                    Button(action: {
                        // TODO: PAUSE
                    },
                    label: {
                        Image(systemName: "pause.circle")
                            .accentColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                            .font(.system(size: 40))
                    })
                    .padding(.horizontal)
                    
                    Spacer()
                    EnemyStats()
                        .padding()
                    
                }
                
                CharacterStats()
                    .padding()
                Spacer()
                
                
                ZStack{
                    HStack{
                        Button(action: {
                            characterEnergy-=10
                            // TODO: ENEMY TAKES DAMAGE
                        },
                        label: {
                            Image(systemName: "flame")
                                .accentColor(.orange)
                                .font(.system(size: 40))
                        })
                        .padding(25)
                        
                        Button(action: {
                            characterEnergy -= 25
                            // TODO: ENEMY TAKES EXTRA DAMAGE
                        },
                        label: {
                            Image(systemName: "sparkles")
                                .accentColor(.yellow)
                                .font(.system(size: 40))
                        })
                        .padding()
                        
                        Button(action: {
                            // TODO: CHOOSE HEAL OPTION
                        },
                        label: {
                            Image(systemName: "heart")
                                .accentColor(.red)
                                .font(.system(size: 40))
                        })
                        .padding()
                    }.zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    
                    Rectangle()
                        .cornerRadius(radius: 25.0, corners: [.topLeft, .topRight])
                        .foregroundColor(.white)
                        .zIndex(0)
                    
                }
            }
        }
    }
}


struct EnemyStats:View{
    var health : Int64 = 65
    var maxHealth : Int64 = 100
    
    func calculateHeight(for value: Int64, maxValue: Int64, height: CGFloat) -> CGFloat{
        return (CGFloat(value)/CGFloat(maxValue)) * height
    }
    
    var body: some View{
        
        VStack{
            ZStack(alignment:.trailing){
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(Color.white)
                    .frame(width:  UIScreen.main.bounds.width/2, height: 18, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.top, 15)
                    .padding(.bottom,10)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width:  calculateHeight(for: health, maxValue: maxHealth, height: UIScreen.main.bounds.width/2), height: 18, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(radius: 25, corners: [.bottomRight, .topRight])
                    .padding(.top, 15)
                    .padding(.bottom,10)
            }
            
            ZStack{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width/2 , height: UIScreen.main.bounds.width/2)
                
                Image(systemName: "sparkle")
                    .resizable()
                    .foregroundColor(.yellow)
                    .frame(width: UIScreen.main.bounds.width/2-5, height: UIScreen.main.bounds.width/2-5)
                
            }
        }
    }
}


struct CharacterStats: View{
    var health : Int64 = 65
    var maxHealth : Int64 = 100
    
    func calculateHeight(for value: Int64, maxValue: Int64, height: CGFloat) -> CGFloat{
        return (CGFloat(value)/CGFloat(maxValue)) * height
    }
    var body: some View{
        VStack{
            HStack(alignment: .bottom){
                
                ZStack{
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .fill(Color.white)
                        .frame(width: UIScreen.main.bounds.width/2 , height: UIScreen.main.bounds.width/2)
                    Image(systemName: "sparkle")
                        .resizable()
                        .foregroundColor(.yellow)
                        .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
                    
                }
           
                HStack(alignment:.bottom){
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.blue)
                            .frame(width:20, height: calculateHeight(for: 75, maxValue: 100, height: UIScreen.main.bounds.width/2))
                            .zIndex(1)
                        
                        
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.white)
                            .frame(width:20, height: calculateHeight(for: maxHealth, maxValue: maxHealth, height: UIScreen.main.bounds.width/2))
                            .zIndex(0)
                    }
                    
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.white)
                            .frame(width:20, height: calculateHeight(for: maxHealth, maxValue: maxHealth, height: UIScreen.main.bounds.width/2))
                            .zIndex(0)
                        
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.green)
                            .frame(width:20, height: calculateHeight(for: 85, maxValue: maxHealth, height: UIScreen.main.bounds.width/2))
                            .zIndex(1)
                    }                   
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct EnemyView_Previews: PreviewProvider {
    static var previews: some View {
        EnemyView()
    }
}
