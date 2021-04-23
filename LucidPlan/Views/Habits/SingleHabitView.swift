//
//  SingleHabitView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 22.04.2021.
//

import SwiftUI

struct SingleHabitView: View {
    @ObservedObject var habitManager : HabitManager
    @Environment(\.managedObjectContext) var context
    @State var isEdited = false
    
    var habit : Habit
    
    init(manager : HabitManager, habit: Habit){
        habitManager = manager
        self.habit = habit
    }
    
    var body: some View {
        HStack{
            
            HStack{
                if !isEdited{
                    Text(habit.title ?? "")
                        .font(.system(size: 20))
                    
                    Text(" \(habit.points)")
                    
                }else{
                    TextField(habit.title ?? "", text: $habitManager.title)
                        .font(.system(size: 20))
                    
                    Button(action: {
                        habitManager.writeData(context: context)
                        isEdited.toggle()
                    }, label: {
                        Text("Save")
                        
                    })
                    
                    Button(action: {
                        isEdited.toggle()
                    }, label: {
                        Text("Cancel")
                    })
                }
                
                Spacer()
                
            }
            .contentShape(RoundedRectangle(cornerRadius: 5))
            .contextMenu(ContextMenu(menuItems: {
                Button(action: {
                    habitManager.editData(habit: habit)
                    isEdited.toggle()
                    
                }, label: {
                    Text("Edit")
                })
                
                Button(action: {
                    habitManager.delete(context: context, habit: habit)
                }, label: {
                    Text("Delete")
                })
            }))
            
            Button(action: {
                habitManager.addPoints(context: context , habit: habit, numberOfPoints: 5)
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .zIndex(0.0)
                        .frame(width: 53, height: 53, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                        .zIndex(0)
                    Text("+")
                        .offset(x: 0, y: -3)
                        .font(.system(size: 55))
                        .zIndex(0.5)
                        .foregroundColor(.white)
                }
            })
            .disabled(isEdited)
            
            Button(action: {habitManager.addPoints(context: context, habit: habit, numberOfPoints: -5)
                
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 8).zIndex(0.0)
                        .frame(width: 53, height: 53, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(red: 120/255, green: 127/255, blue: 246/255))
                        .zIndex(0)
                    
                    Text("-")
                        .offset(x: 0, y: -2)
                        .font(.system(size: 60))
                        .zIndex(0.5)
                        .foregroundColor(.white)
                    
                }
            })
            .disabled(isEdited)
        }
        
        
    }
}

