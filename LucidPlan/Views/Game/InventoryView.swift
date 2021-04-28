//
//  InventoryView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct InventoryView: View {
    var body: some View {
        VStack(spacing:1){
            ZStack{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                
                Image(systemName: "sparkle")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.yellow)
            }

            ZStack(alignment:.bottom){
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(red: 255/255, green: 204/255, blue: 77/255))
                    .frame(width: .infinity, height: 425)
                
                VStack{
                    ForEach(0..<4){_ in
                        HStack{
                            ForEach(0..<4){_ in
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color(red: 226/255, green: 162/255, blue: 1/255))
                                    .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                            }
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                    }
                    
                    
                }
            }.padding()
            
        }
        
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
