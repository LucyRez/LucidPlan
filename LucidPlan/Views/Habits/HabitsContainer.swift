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
    @Environment(\.managedObjectContext) var context
    
    var fetchRequest : FetchRequest<Habit>
    var habits : FetchedResults<Habit>{
        fetchRequest.wrappedValue
    }
    
    
    init(manager: HabitManager){
        self.manager = manager
        fetchRequest = FetchRequest(entity: Habit.entity(), sortDescriptors: [])
    }
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(habits){habit in
                    SingleHabitView(manager: manager, habit: habit)
                      
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        
    }
}


