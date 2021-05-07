//
//  ShopView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct ShopView: View {
    let items : [Item] = [Item(title: "Восстановитель здоровья", description: "Красная жидкость похожая на кровь?", price: 100, imageName: "sparkle", type: "potion"), Item(title: "Повреждающее зелье", description: "Капля этого зелья способна ранить кого угодно", price: 100, imageName: "sparkle", type: "potion"), Item(title: "Восстановитель энергии", description: "Эх, что-то спать захотелось...", price: 100, imageName: "sparkle", type: "potion")]
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var shopManager = ShopManager()
    @State var chosen : Item?
    
    var body: some View {
        VStack{
            HStack(alignment:.top){
                ZStack{
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    Image(systemName: chosen?.imageName ?? items[0].imageName)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.yellow)
                }
                Spacer()
                
                VStack{
                    Text(chosen?.description ?? "Choose an item")
                        .font(.system(size: 18))
                    Spacer()
                    Button(action:{
                        shopManager.writeData(context: context, boughtItem: chosen!)
                    },
                    label: {
                        Text("Buy")
                    })
                    .disabled(chosen == nil)
                }
                .frame(height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
