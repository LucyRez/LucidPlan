//
//  InventoryView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

struct Inventory : View{
    var fetchRequest : FetchRequest<ShopItem>
    
    var inventoryItems : FetchedResults<ShopItem>{
        fetchRequest.wrappedValue
    }
    
    init(){
        fetchRequest = FetchRequest(entity: ShopItem.entity(), sortDescriptors: [])
    }
    
    var body: some View{
        InventoryView(items: inventoryItems, count: inventoryItems.count)
    }
}

struct InventoryView: View {
    @ObservedObject var inventory = InventoryManager()
    @Environment(\.managedObjectContext) var context
    @State var chosen : ShopItem?
    @State var countItems : Int
    
    let layout = [GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible())]
    
    var inventoryItems : FetchedResults<ShopItem>
    
    init(items: FetchedResults<ShopItem>, count: Int){
        inventoryItems = items
        _countItems = State(initialValue: count)
    }
    
    var body: some View {
        VStack(spacing:1){
            
            HStack(alignment:.bottom){
                Text("\(countItems)")
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
                
                VStack{
                    Text(chosen?.title ?? "Choose an item")
                    Button(action: {
                        countItems-=1
                        inventory.delete(context: context, item: chosen!)
                    },
                    label: {
                        Text("Equip")
                            .font(.title)
                    })
                    .disabled(chosen == nil)
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
                            Text(item.title ?? "default")
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

//struct InventoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryView()
//    }
//}
