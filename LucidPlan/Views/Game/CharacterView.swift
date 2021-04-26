//
//  CharacterView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 24.04.2021.
//

import SwiftUI

struct CharacterView: View {
    
    @ObservedObject var characterManager: CharacterManager
    var maxHealth : Int64 = 100
    var maxExp : Int64 = 1000
    
    init(manager: CharacterManager){
        characterManager = manager
    }
    
    func calculateHeight(for value: Int64, maxValue: Int64, height: CGFloat) -> CGFloat{
        return (CGFloat(value)/CGFloat(maxValue)) * height
    }
    
    var body: some View {
        HStack(alignment: .bottom){
            Image(systemName: "sparkle")
                .resizable()
                .frame(width: 220, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.yellow)
               
            
            
            GeometryReader{geometry in
                HStack(alignment:.bottom){
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.blue)
                            .frame(height: calculateHeight(for: characterManager.getExp(), maxValue: maxExp, height: geometry.frame(in: .global).height), alignment: .bottom)
                            .zIndex(1)
                        
                      
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .fill(Color.white)
                                .frame(height: calculateHeight(for: maxHealth, maxValue: maxHealth, height: geometry.frame(in: .global).height), alignment: .bottom)
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


struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(manager: CharacterManager())
    }
}
