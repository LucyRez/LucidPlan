//
//  HabitsContainer.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 22.04.2021.
//

import SwiftUI
import CoreData


struct HabitsContainer: View {
    @ObservedObject var manager : HabitManager
    @ObservedObject var gameManager : GameManager
    @Environment(\.managedObjectContext) var context
    
    var fetchRequest : FetchRequest<Habit>
    var habits : FetchedResults<Habit>{
        fetchRequest.wrappedValue
    }
    
    
    init(habitManager: HabitManager, gameManager: GameManager){
        self.manager = habitManager
        self.gameManager = gameManager
        fetchRequest = FetchRequest(entity: Habit.entity(), sortDescriptors: [])
    }
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(habits){habit in
                    SingleHabitView(habitManager: manager, habit: habit, gameManager: gameManager)
                      
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        
    }
}


