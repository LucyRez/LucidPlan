//
//  TeamView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 08.05.2021.
//

import SwiftUI

struct TeamView: View {
    @StateObject var socketManager = GameNetworkManager()
    @ObservedObject var userManager : UserManager
    @State var createRoom = false
    @State var game : ReceivedGameInfo = ReceivedGameInfo(_id: "", enemy: ReceivedEnemyInfo(_id: "", damage: 0, health: 0, imageName: "", maxHealth: 0), messages: [], users: [])
    
    func getGame(){
        
        socketManager.getGame(completionHandler: { data in
            game = data
            print(game)
        })
        
    }
    
    func askForGame(){
        socketManager.askForGame(id: userManager.user!.groupId!)
    }
    
    var body: some View {
        ZStack{
           
            if userManager.user?.groupId == ""{
                TeamCodeView(createRoom: $createRoom, userManager: userManager, socketManager: socketManager)
            }
            else{
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), .white]), startPoint: .top, endPoint: .center)
                .ignoresSafeArea()
            
            VStack{
                
                HStack(alignment:.top, spacing: -50){
                    TeamEnemyView(game: $game)
                    NavigationLink(destination: Text("Messages View"),
                                   label: {
                                    Image(systemName: "message.fill")
                                        .foregroundColor(.blue)
                                        .font(.title)
                                    
                                   })
                }
                
                Spacer()
                
            }
            .padding()
            .zIndex(0)
            .onAppear(perform: getGame)
            .onAppear(perform: askForGame)
            
        }
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear(perform: socketManager.setSocket)
        .onDisappear(perform: socketManager.disconnect)
        
        
    }
}

struct TeamCodeView: View {
    
    @State var code : String = ""
    @Binding var createRoom : Bool
    @ObservedObject var userManager : UserManager
    @ObservedObject var socketManager: GameNetworkManager
    
    @State var id : String = ""

    @Environment(\.managedObjectContext) var context
    
    func getCode(){
        socketManager.getCode(completionHandler: {data in
            if data.success{
                userManager.setGroupId(context: context, id: code)
            }
        })
    }
    
    var body: some View{
        VStack{
            Spacer()
            Text("Введите код команды")
                .fontWeight(.semibold)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            ZStack{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                TextField("Запишите код сюда...", text: $code)
                    
                    .padding(40)
            }
            
            Button(action: {
                if createRoom{
                    id = code
                    socketManager.sendCode(code: code, userManager: userManager, hp: 100, imageName: "sparkle")
                    // SET ID AND FETCH NEWLY CREATED ROOM
                    
                }else{
                    id = code
                    socketManager.checkCode(code: code, userManager: userManager, hp: 100, imageName: "sparkle")
                }
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.black.opacity(0.1))
                        .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/15)
                        
                    Text(createRoom ? "Создать" : "Войти")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    
                }
            })
            
            if !createRoom{
            HStack{
                Text("Нет команды?")
                Button(action: {
                    withAnimation(.spring()){
                        createRoom = true
                        
                    }
                }, label: {
                    Text("Создать")
                })
            }
            .padding()
                
            }
            
            Spacer()
            
        }
        .background(Color.white.ignoresSafeArea())
        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
        .onAppear(perform: getCode)
    }
}

struct TeamEnemyView: View{
    
    @Binding var game : ReceivedGameInfo
    
    // Function is used to calculate height of the health bar
    func calculateHeight(for value: Int64, maxValue: Int64, height: CGFloat) -> CGFloat{
        return (CGFloat(value)/CGFloat(maxValue)) * height
    }
    
    var body: some View{
        
        
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                
                Image(game.enemy.imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.yellow)
            }
            .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4)
            
            // Enemy's health bar
            ZStack(alignment:.trailing){
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(Color.white)
                    .frame(width:  UIScreen.main.bounds.width/1.6, height: 18)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.red)
                    .frame(width:  calculateHeight(for: Int64(game.enemy.health), maxValue: Int64(game.enemy.maxHealth), height: UIScreen.main.bounds.width/1.6), height: 18)
                
            }
            Spacer()
            
            ZStack(alignment: .top){
                Rectangle()
                    .cornerRadius(radius: 25.0, corners: [.topLeft, .topRight])
                    .foregroundColor(.white)
                    .zIndex(0)
                VStack{
                    HStack{
                        Text("Rating")
                            .font(.system(size: 40))
                            .fontWeight(.semibold)
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 40))
                    }
                    
                    ScrollView{
                        VStack(alignment:.leading){
                            ForEach(game.users, id: \.self ){(user : ReceivedUserInfo) in
                                Text(user.nickname)
                            }
                        }
                        
                    }.zIndex(0.5)
                }
                
            }
        }
    }
}

//struct TeamView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamView()
//    }
//}


