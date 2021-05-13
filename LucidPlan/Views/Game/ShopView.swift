//
//  ShopView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct ShopView: View {
    let items : [Item] = [Item(title: "Зелье здоровья", description: "Восстанавливает всё здоровье во время битвы", price: 100, imageName: "health", type: "potion"), Item(title: "Ядовитое зелье", description: "Наносит 50 очков урона любому противнику", price: 100, imageName: "harm", type: "potion"), Item(title: "Зелье энергии", description: "Восстанавливает всю энергию", price: 100, imageName: "energy", type: "potion"), Item(title: "Robin", description: "Персонаж с удвоенной атакой", price: 2000, imageName: "robin" , type: "character")]
    
    @Environment(\.managedObjectContext) var context
    @StateObject var shopManager = ShopManager()
    @ObservedObject var userManager : UserManager
    @State var chosen : Item?
    
    var body: some View {
        VStack{
            HStack(alignment:.top){
                ZStack{
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    Image(chosen?.imageName ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.yellow)
                }
                Spacer()
                
                VStack{
                    Text(chosen?.description ?? "Выберите товар")
                        .font(.system(size: 18))
                    Spacer()
                    Button(action:{
                        if chosen!.price <= userManager.getCoins(){
                            userManager.addCoins(context: context, amount: Int64(0 - chosen!.price))
                            shopManager.writeData(context: context, boughtItem: chosen!)}
                    },
                    label: {
                        Text("Buy")
                    })
                    .disabled(chosen == nil || chosen!.price > userManager.getCoins())
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

