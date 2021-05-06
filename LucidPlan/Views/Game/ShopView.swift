//
//  ShopView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct ShopView: View {
    let items : [Item] = [Item(title: "Восстановитель здоровья", description: "Красная жидкость похожая на кровь?", price: 100, imageName: "", type: "heal"), Item(title: "Повреждающее зелье", description: "Капля этого зелья способна ранить кого угодно", price: 100, imageName: "", type: "harm"), Item(title: "Восстановитель энергии", description: "Эх, что-то спать захотелось...", price: 100, imageName: "", type: "energy")]
    
    var image : UIImage = UIImage(systemName: "sparkle") ?? UIImage()
    @State var chosen : Item?
    
    init(){
        chosen = items[0]
    }
    
    var body: some View {
        VStack{
            HStack(alignment:.top){
            ZStack{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                
                Image(systemName: "sparkle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.yellow)
            }
                Spacer()
                
                Text(chosen?.description ?? items[0].description)
                    .font(.system(size: 18))
            }
            .padding()
            
            ScrollView{
            ForEach(items, id: \.self){item in
                SingleShopItem(price: item.price, title: item.title, type: item.type, description: item.description, imageName: item.imageName)
                    .padding()
                    .onTapGesture {
                        chosen = item
                    }
            }
                
            }
           
        }
    }
}

struct SingleShopItem: View{
    var price : Int
    var title : String
    var type : String
    var description : String
    var imageName : String
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                .frame(width: .infinity, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack{
                Text(title)
                    .bold()
                Spacer()
                Text("\(price)")
                    .bold()
            }
            .padding()
            .font(.system(size: 20))
            .foregroundColor(.white)
        }
        
    }
    
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
