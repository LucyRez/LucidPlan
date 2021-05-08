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
    var body: some View {
        ZStack{
           
            if userManager.user?.groupId == ""{
                TeamCodeView(createRoom: $createRoom, socketManager: socketManager)
            }
            
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), .white]), startPoint: .top, endPoint: .center)
                .ignoresSafeArea()
            
            VStack{
                
                HStack(alignment:.top, spacing: -50){
                    TeamEnemyView()
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
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear(perform: socketManager.setSocket)
        
        
    }
}

struct TeamCodeView: View {
    
    @State var code : String = ""
    @Binding var createRoom : Bool
    @ObservedObject var socketManager: GameNetworkManager
    
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
                    socketManager.sendCode(code: code)
                    // SET ID AND FETCH NEWLY CREATED ROOM
                    
                }else{
                    socketManager.checkCode(code: code)
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
    }
}

struct TeamEnemyView: View{
    
    // Function is used to calculate height of the health bar
    func calculateHeight(for value: Int64, maxValue: Int64, height: CGFloat) -> CGFloat{
        return (CGFloat(value)/CGFloat(maxValue)) * height
    }
    
    var body: some View{
        
        
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                
                Image(systemName: "sparkle")
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
                    .frame(width:  calculateHeight(for: 65, maxValue: 100, height: UIScreen.main.bounds.width/1.6), height: 18)
                
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
                            Text("Lucy")
                                .padding()
                            Text("Another Player")
                                .padding()
                            
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


