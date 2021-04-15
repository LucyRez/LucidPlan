//
//  LoginView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import SwiftUI

struct LoginView: View {
    
    @State var justOpened : Bool = false
    @State var nickname : String = ""
    @State var saved : String?
    
    func saveNickname(){
        UserDefaults.standard.set(nickname, forKey: "nickname3")
    }
    
    init() {
        self.nickname = UserDefaults.standard.object(forKey: "nickname3") as? String ?? ""
        self.saved = self.nickname
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 50){
                // Не переходим в чат, пока не подтверждено имя пользователя.
                NavigationLink(
                    destination: TabBarView()
                        .navigationBarHidden(true),
                   //     .navigationBarBackButtonHidden(true),
                    isActive: $justOpened)
                {
                    EmptyView()
                }
                
                
                Text("LUCID \nPLAN.")
                    .bold()
                    .font(.system(size: 60))
                    .padding(.bottom, 50)
                
                
                if(saved == ""){
                    TextField("Write your nickname here...", text: $nickname)
                        .frame(width: 340, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 20))
                        .padding()
                        .background(Color.gray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .padding(20)
                    
                }else{
                    Text("Welcome, \(nickname)!")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(20)
                }
                
                // Кнопка для входа в чат (не активна, когда ничего не ввели в строке с именем).
                Button(action: {
                    saveNickname()
                    justOpened.toggle()
                },
                label: {
                    Text("Enter")
                        .font(.system(size: 25))
                        .padding()
                        .frame(width: 200, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    
                }).disabled(nickname.isEmpty)
                
                Spacer()
                
            }
           
         
        }
        .onAppear(perform: {
            self.nickname = UserDefaults.standard.object(forKey: "nickname") as? String ?? ""
            self.saved = nickname
        })
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
