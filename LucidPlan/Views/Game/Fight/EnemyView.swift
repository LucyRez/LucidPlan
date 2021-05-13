//
//  EnemyView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.04.2021.
//

import SwiftUI

/**
 Fight view
 */
struct EnemyView: View {
    @State var characterEnergy : Int64 = 100
    @State var characterHealth : Int64 = 100
    @State var enemyHealth : Int64 = 100
    
    @State var showEndView : Bool = false
    @State var playerWon : Bool = false
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var userManager : UserManager
    @ObservedObject var characterManager : CharacterManager
    
    var images: [String] = ["blitz", "dreamon", "frosty", "corwus"]
    
    var enemyDamage : Int64
    var enemyCritPercent : Int64
    
    var fetchRequest : FetchRequest<ShopItem>
    
    var inventoryItems : FetchedResults<ShopItem>{
        fetchRequest.wrappedValue
    }
    
    init(userManager: UserManager, characterManager : CharacterManager){
        fetchRequest = FetchRequest(entity: ShopItem.entity(), sortDescriptors: [])
        self.userManager = userManager
        enemyDamage = Int64.random(in: 8...10)
        enemyCritPercent = Int64.random(in: 2...4)
        self.characterManager = characterManager
    }
    
    func checkPotions() -> Bool{
        for item in inventoryItems {
            if item.imageName == "health" {
                return true
            }
        }
        
        return false
    }
    
    func checkWinner() -> Bool{
        if enemyHealth <= 0 && characterHealth > 0{
            withAnimation(.easeOut){
                showEndView = true
            }
            userManager.addCoins(context: context, amount: 100)
            userManager.addToExp(expPoints: 500, context: context)
            return true
        }else if characterHealth <= 0{
            withAnimation(.easeOut){
                showEndView = true
                
            }
            return false
        }
        return false
    }
    
    var body: some View {
        ZStack{
            Color.blue.opacity(0.2).ignoresSafeArea()
            if showEndView{
                EndGameView(win: playerWon)
                    .zIndex(1.0)
            }
            
            VStack{
                
                // Here is enemy view
                HStack(alignment:.top){
                    Spacer()
                    EnemyStats(health: $enemyHealth, maxHealth:enemyHealth,imageName: images[Int.random(in: 0...3)])
                        .padding()
                }
                
                CharacterStats(health: $characterHealth, maxHealth: characterHealth, energy: $characterEnergy,
                               maxEnergy: characterEnergy, image: characterManager.getImageName())
                    .padding()
                
                Spacer()
                
                
                    // Here is game menu for choosing action
                    ZStack{
                        HStack{
                            Button(action: {
                                characterEnergy-=2
                                enemyHealth-=5
                                if enemyHealth > 0{
                                    let rand = Int.random(in: 0...100)
                                    if rand <= enemyCritPercent {
                                        characterHealth -= enemyDamage*2
                                    }else{
                                        characterHealth -= enemyDamage
                                    }
                                }
                                playerWon = checkWinner()
                            },
                            label: {
                                VStack{
                                    Image(systemName: "flame")
                                        .accentColor(.orange)
                                        .font(.system(size: 40))
                                    Text("Обычная атака")
                                        .foregroundColor(.orange)
                                }
                            })
                            .padding(20)
                            
                            Button(action: {
                                characterEnergy -= 5
                                enemyHealth-=10
                                if enemyHealth > 0{
                                    let rand = Int.random(in: 0...100)
                                    if rand <= enemyCritPercent {
                                        characterHealth -= enemyDamage*2
                                    }else{
                                        characterHealth -= enemyDamage
                                    }
                                }
                                playerWon = checkWinner()
                            },
                            label: {
                                VStack{
                                    Image(systemName: "sparkles")
                                        .accentColor(.yellow)
                                        .font(.system(size: 40))
                                    Text("Особая атака")
                                        .foregroundColor(.yellow)
                                    
                                }
                            })
                            .padding()
                            
                            Button(action: {
                                if checkPotions(){
                                    characterHealth = 100
                                }
                            },
                            label: {
                                VStack{
                                    Image(systemName: "heart")
                                        .accentColor(.red)
                                        .font(.system(size: 40))
                                    Text("Восстановить здоровье")
                                        .foregroundColor(.red)
                                }
                            })
                            .padding()
                        }.zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        
                        Rectangle()
                            .cornerRadius(radius: 25.0, corners: [.topLeft, .topRight])
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
                            .foregroundColor(.white)
                            .zIndex(0)
                        
                    }
                    .padding()
                
            }
            .opacity(showEndView ? 0.1 : 1)
            .background(showEndView ? Color.black : Color.clear)
            
        }
    }
}


struct EnemyStats:View{
    let enemyNames : KeyValuePairs = ["Dreamon" : "Earth", "Blitz" : "Fire", "Frosty" : "Water", "Corvus" : "Air"]
    
    @Binding var health : Int64
    @State var maxHealth : Int64
    @State var imageName : String
    
    // Function is used to calculate height of the health bar
    func calculateHeight(for value: Int64, maxValue: Int64, height: CGFloat) -> CGFloat{
        return (CGFloat(value)/CGFloat(maxValue)) * height
    }
    
    
    var body: some View{
        
        VStack{
            // Enemy's health bar
            ZStack(alignment:.trailing){
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(Color.white)
                    .frame(width:  UIScreen.main.bounds.width/2, height: 18, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width:  calculateHeight(for: health, maxValue: maxHealth, height: UIScreen.main.bounds.width/2), height: 18)
                    .cornerRadius(radius: 25, corners: [.bottomRight, .topRight])
            }
            .padding(.top, 15)
            .padding(.bottom,10)
            
            // Enemy's picture representation
            ZStack{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width/2 , height: UIScreen.main.bounds.width/2)
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width/2-5, height: UIScreen.main.bounds.width/2-5)
                
            }
        }
    }
}


struct CharacterStats: View{
    @Binding var health : Int64
    @State var maxHealth : Int64
    @Binding var energy : Int64
    @State var maxEnergy : Int64
    var image : String
    
    func calculateHeight(for value: Int64, maxValue: Int64, height: CGFloat) -> CGFloat{
        return (CGFloat(value)/CGFloat(maxValue)) * height
    }
    
    var body: some View{
        VStack{
            HStack(alignment: .bottom){
                
                ZStack{
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .fill(Color.white)
                        .frame(width: UIScreen.main.bounds.width/2 , height: UIScreen.main.bounds.width/2)
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
                    
                }
                
                HStack(alignment:.bottom){
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.blue)
                            .frame(width:20, height: calculateHeight(for: energy, maxValue: maxEnergy, height: UIScreen.main.bounds.width/2))
                            .zIndex(1)
                        
                        
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.white)
                            .frame(width:20, height: UIScreen.main.bounds.width/2)
                            .zIndex(0)
                    }
                    
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.white)
                            .frame(width:20, height: UIScreen.main.bounds.width/2)
                            .zIndex(0)
                        
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.green)
                            .frame(width:20, height: calculateHeight(for: health, maxValue: maxHealth, height: UIScreen.main.bounds.width/2))
                            .zIndex(1)
                    }                   
                }
                .padding(.horizontal)
                
                Spacer()
                
                
            }
        }
    }
}


