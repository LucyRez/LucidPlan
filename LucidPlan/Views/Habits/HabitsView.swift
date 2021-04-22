//
//  HabitsView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 22.04.2021.
//

import SwiftUI

struct HabitsView: View {
    @StateObject var habitManager = HabitManager()
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Button(action: {
                    // TODO экран настроек
                },
                label: {
                    Text("...")
                        .bold()
                        .font(.system(size: 50))
                        .frame(width: 50, height: 50, alignment: .bottom)
                })
                
                Spacer()
            }.padding(.leading)
            
            Text("Трекер привычек")
                .font(.title)
                .bold()
                .padding(20)
            
            HabitsContainer(manager: habitManager)
                .padding()
            
            HStack{
                ZStack{
                    TextField("Add new habit...", text: $habitManager.title)
                        .font(.system(size: 20))
                        .padding(.leading).zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    
                    RoundedRectangle(cornerRadius: 22)
                        .opacity(0.2)
                        .frame(width: .infinity, height: 50)
                        .zIndex(0)
                }
                
                Button(action: {
                    habitManager.writeData(context: context)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                        .font(.system(size: 35))
                    
                })
            }
            .padding()
            
        }
    }
}

struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
    }
}
