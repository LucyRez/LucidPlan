//
//  EndGameView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 06.05.2021.
//

import SwiftUI

struct EndGameView: View {
    var win : Bool
    
    var body: some View {
        VStack{
            Spacer()
            Text(win ? "Победа!" : "Поражение")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.semibold)
            Spacer()
            
            HStack(alignment:.top){
                Text(win ? "Награда:" : "Попробуйте ещё раз")
                
                VStack{
                    HStack{
                        Text(win ? "50" : "")
                        if win{
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.yellow)
                            
                        }
                        
                    }
                    
                    HStack{
                        if win{
                        Text("200")
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.orange)
                            
                        }
                        
                    }
                    
                }
            }
            .font(.system(size: 20))
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/3)
        .background(Color.white.ignoresSafeArea())
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        
    }
}
