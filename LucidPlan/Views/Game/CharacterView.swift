//
//  CharacterView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 24.04.2021.
//

import SwiftUI

struct CharacterView: View {
    
    @ObservedObject var characterManager: CharacterManager
    @ObservedObject var userManager : UserManager
    var maxHealth : Int64 = 100
    var maxExp : Int64 = 1000
    
    init(characterManager: CharacterManager, userManager: UserManager){
        self.characterManager = characterManager
        self.userManager = userManager
    }
    
    func calculateHeight(for value: Int64, maxValue: Int64, height: CGFloat) -> CGFloat{
        return (CGFloat(value)/CGFloat(maxValue)) * height
    }
    
    var body: some View {
        HStack(alignment: .bottom){
            Image((characterManager.getImageName()))
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 280, alignment: .leading)
               
            
            
            GeometryReader{geometry in
                HStack(alignment:.bottom){
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.blue)
                            .frame(height: calculateHeight(for: userManager.getExp(), maxValue: maxExp, height: geometry.frame(in: .global).height), alignment: .bottom)
                            .zIndex(1)
                        
                      
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .fill(Color.white)
                                .frame(height: calculateHeight(for: maxExp, maxValue: maxExp, height: geometry.frame(in: .global).height), alignment: .bottom)
                                .zIndex(0)
                    }
                
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.white)
                            .frame(height: calculateHeight(for: maxHealth, maxValue: maxHealth, height: geometry.frame(in: .global).height), alignment: .bottom)
                            .zIndex(0)
                        
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.green)
                            .frame(height: calculateHeight(for: characterManager.getHealth(), maxValue: maxHealth, height: geometry.frame(in: .global).height), alignment: .bottom)
                            .zIndex(1)
                    }
                    
                    
                }
                
                
            }
        }.frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

