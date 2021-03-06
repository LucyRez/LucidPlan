//
//  InventoryView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct Inventory : View{
    @Environment(\.managedObjectContext) var context
    @ObservedObject var characterManager : CharacterManager
    @ObservedObject var userManager : UserManager
    
   
    var fetchRequest : FetchRequest<ShopItem>
    
    var inventoryItems : FetchedResults<ShopItem>{
        fetchRequest.wrappedValue
    }
    
    init(characterManager: CharacterManager, userManager: UserManager){
        fetchRequest = FetchRequest(entity: ShopItem.entity(), sortDescriptors: [])
        self.characterManager = characterManager
        self.userManager = userManager
    }
    
    var body: some View{
        InventoryView(items: inventoryItems, count: inventoryItems.count, characterManager: characterManager, userManager: userManager)
        
    }
}

struct InventoryView: View {
    @ObservedObject var characterManager : CharacterManager
    @ObservedObject var inventory = InventoryManager()
    @ObservedObject var userManager : UserManager
    
    @Environment(\.managedObjectContext) var context
    @State var chosen : ShopItem?
    @State var countItems : Int
    
    let layout = [GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible())]
    
    var inventoryItems : FetchedResults<ShopItem>
    
    init(items: FetchedResults<ShopItem>, count: Int, characterManager: CharacterManager, userManager: UserManager){
        inventoryItems = items
        _countItems = State(initialValue: count)
        self.characterManager = characterManager
        self.userManager = userManager
    }
    
    var body: some View {
        VStack(spacing:1){
            
            HStack(alignment:.bottom){
                Text("\(countItems)")
                ZStack{
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    Image(chosen?.imageName ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.yellow)
                }
                
                VStack{
                    Text(chosen?.title ?? "???????????????? ??????????????")
                        .font(.system(size: 18))
                        
                    Button(action: {
                        if chosen?.type == "character"{
                            characterManager.changeImage(name: chosen?.imageName ?? "sparkle", context: context)
                            countItems-=2
                            inventory.delete(context: context, item: chosen!)
                        }else if chosen?.imageName == "energy"{
                            userManager.addEnergy(context: context, amount: 100)
                            inventory.delete(context: context, item: chosen!)
                        }
                    },
                    label: {
                        Text("????????????????????????")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    })
                    .disabled(chosen == nil || chosen?.type != "character" && chosen?.imageName != "energy")
                    .padding()
                    
                }
            }
            
            ZStack(alignment: .top){
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(red: 255/255, green: 204/255, blue: 77/255))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.5)
                    .zIndex(0)
                
                LazyVGrid(columns: layout, spacing: 8){
                    ForEach(inventoryItems){(item:ShopItem) in
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color(red: 226/255, green: 162/255, blue: 1/255))
                                .frame(width: UIScreen.main.bounds.width/4.5, height:  UIScreen.main.bounds.width/4.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            Image(item.imageName ?? "")
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    chosen = item
                                }
                                .zIndex(1)
                            
                        }
                        
                    }.zIndex(1)
                
                    
                    ForEach(0..<20 - countItems){_ in
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(red: 226/255, green: 162/255, blue: 1/255))
                            .frame(width: UIScreen.main.bounds.width/4.5, height:  UIScreen.main.bounds.width/4.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                    }
                    
                }
                .padding()
                
            }
        }
        
    }
}

