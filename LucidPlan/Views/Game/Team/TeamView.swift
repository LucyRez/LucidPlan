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
    @ObservedObject var characterManager : CharacterManager
    
    @State var roomCreated = false
    @State var roomJoined = false
    
    
    var body: some View {
        ZStack{
            
            if !roomCreated && userManager.user?.groupId == ""{
                TeamCodeView(wasCreated: $roomCreated, userManager: userManager, socketManager: socketManager)
            }
            else{
                if roomJoined{
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), .white]), startPoint: .top, endPoint: .center)
                        .ignoresSafeArea()
                    
                    VStack{
                        
                        HStack(alignment:.top, spacing: -50){
                            TeamEnemyView(socketManager: socketManager, userManager: userManager )
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
                    
                }else{
                    DownloadGameView(userManager: userManager, socketManager: socketManager, roomJoined: $roomJoined)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear(perform: socketManager.setSocket)
        .onDisappear(perform: socketManager.disconnect)
        
    }
}

struct DownloadGameView : View{
    @ObservedObject var userManager : UserManager
    @ObservedObject var socketManager: GameNetworkManager
    @Binding var roomJoined : Bool
    
    func getCode(){
        socketManager.getCode(completionHandler: {data in
            if data.success{
                withAnimation(.spring()){
                    roomJoined = true
                    
                }
            }
        })
    }
    
    func oldUser(){
        socketManager.askForGame(id: userManager.user!.groupId!)
    }
    
    var body: some View{
        VStack(spacing:20){
            HStack{
                Text("Код команды: ")
                    .font(.title)
                    .fontWeight(.semibold)
                Text(userManager.user!.groupId!)
                    .font(.title)
            }
            .padding()
            
            Button(action: {oldUser()}, label: {
                Text("Войти")
                    .font(.title)
            })
            .padding()
            
        }
        .onAppear(perform: getCode)
        
    }
}

struct TeamCodeView: View {
    
    @State var code : String = ""
    @State var createRoom : Bool = false
    @Binding var wasCreated : Bool
    @ObservedObject var userManager : UserManager
    @ObservedObject var socketManager: GameNetworkManager
    
    @State var id : String = ""
    
    @Environment(\.managedObjectContext) var context
    
    func getCode(){
        socketManager.getCode(completionHandler: {data in
            if data.success{
                userManager.setGroupId(context: context, id: code)
                withAnimation(.spring()){
                    wasCreated = true
                    
                }
            }
        })
    }
    
    var body: some View{
        VStack{
            Spacer()
            Text("Введите код команды")
                .fontWeight(.semibold)
                .font(.title)
            
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/10)
                
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
    @ObservedObject var socketManager : GameNetworkManager
    @State var game : ReceivedGameInfo = ReceivedGameInfo(_id: "", enemy: ReceivedEnemyInfo(_id: "", damage: 0, health: 0, imageName: "", maxHealth: 0), messages: [], users: [])
    @ObservedObject var userManager : UserManager
    
    func getGame(){
        socketManager.getGame(completionHandler: { data in
            game = data
            print(game)
        })
    }
    
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
        .onAppear(perform: getGame)
        
        
    }
}



