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
                    .padding(.bottom, 50)
                
                
                if( saved == ""){
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
    }
    
}

