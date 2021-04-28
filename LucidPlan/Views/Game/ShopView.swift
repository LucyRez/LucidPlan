//
//  ShopView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct ShopView: View {
    var image : UIImage = UIImage(systemName: "sparkle") ?? UIImage()
    
    var body: some View {
        VStack{
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
            
            SingleShopItem()
                .padding()
        }
    }
}

struct SingleShopItem: View{
    var price : Int = 50
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                .frame(width: .infinity, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack{
                Text("Название предмета")
                    .bold()
                Spacer()
                Text("\(price)")
                    .bold()
            }
            .padding()
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
        }
        
    }
    
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
