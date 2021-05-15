//
//  LoginView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 29.03.2021.
//

import SwiftUI
import CoreData

struct LoginView: View {
    
    @State var justOpened : Bool = false
    @State var nickname : String = ""
    var saved : String
    
    init(context: NSManagedObjectContext){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do{
            let fetchRequest = try context.fetch(fetchRequest) as! [User]
            
            if fetchRequest.count != 0 {
                saved = fetchRequest.first!.nickname ?? ""
                _nickname = State(initialValue: saved)
            }else{
                saved = ""
            }
        }catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
  
    var body: some View {
        NavigationView{
           
            HStack{
                Spacer()
                
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 50){
                // Не переходим в чат, пока не подтверждено имя пользователя.
                NavigationLink(
                    destination: TabBarView(nickname: nickname)
                        .navigationBarHidden(true),
                   //     .navigationBarBackButtonHidden(true),
                    isActive: $justOpened)
                {
                    EmptyView()
                }
                
                
                Text("LUCID \nPLAN.")
                    .bold()
                    .font(.system(size: 60))
                    .foregroundColor(Color.black.opacity(0.8))
                    //.shadow(radius: 2)
                    .padding(.bottom, 50)
                
                
                if( saved == ""){
                    TextField("Введите своё имя...", text: $nickname)
                        .frame(width: 340, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 20))
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .padding(20)
                    
                }else{
                    Text("Добро пожаловать, \(nickname)!")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(20)
                }
                
                // Кнопка для входа в чат (не активна, когда ничего не ввели в строке с именем).
                Button(action: {
                    justOpened.toggle()
                },
                label: {
                    Text("Войти")
                        .foregroundColor(Color.black.opacity(0.7))
                        .font(.system(size: 25))
                        .padding()
                        .frame(width: 200, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color.white.opacity(1))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .shadow(radius: 5)
                    
                }).disabled(nickname.isEmpty)
               
                
                Spacer()
                
            }
                Spacer()
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 214/255, blue: 165/255), Color(red: 202/255, green: 255/255, blue: 191/255)]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
            
           
         
        }
    }
    
}

