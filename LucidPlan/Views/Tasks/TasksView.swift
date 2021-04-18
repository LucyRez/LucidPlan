//
//  TasksView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.03.2021.
//

import SwiftUI
import CoreData

/**
 This view serves as a container for tasks.
 */
struct TasksView: View {
    
    var model : TaskViewModel // Task manager
    
    var fetchRequest : FetchRequest<Task>
    
    var tasks : FetchedResults<Task>{
        fetchRequest.wrappedValue
    }
    
    init(filter: Date, model: TaskViewModel){
        // Filter tasks by chosen date
        let start = Calendar.current.startOfDay(for: filter)
        fetchRequest = FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: true)],
                                    predicate: NSPredicate(format: "startDate >= %@ && startDate < %@", start as NSDate,
                                                           Calendar.current.date(byAdding: .day, value: 1, to: start)! as NSDate))
        self.model = model
    }
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: .infinity, height: 1)
                .foregroundColor(.gray)
                .padding()
            
            HStack(spacing:40){
                Text("Время")
                    .bold()
                
                Text("Задача")
                    .bold()
                
                Spacer()
                
                Image(systemName: "list.bullet")
                    .opacity(0.7)
            }
            .foregroundColor(.gray)
            .padding(.horizontal)
            
            List{
                ForEach(tasks){task in
                    SingleTaskView(task: task, model: model)
                        .padding(.bottom)
                }
            }
        }
    }
}


/**
 This is top of the view
 */
struct TopTaskView: View{
    @ObservedObject var model : TaskViewModel
    
    var body: some View{
        // There is only add button
        HStack(alignment:.bottom){
            Button(action: {
                model.active.toggle()
            },
            label: {
                Image(systemName: "plus.circle.fill").accentColor(Color(red: 49/255, green:  245/255, blue: 238/255))
                    .font(.system(size: 45))
            })
            .sheet(isPresented: $model.active, content: {
                AddTaskView(task: model)
                
            })
            
            Spacer()
        }
        .padding(.bottom, 10)
    }
}


/**
 The view used to represent a single date in the scrollview.
 */
struct DateView: View{
    
    let date : Date
    
    // Function gets name of the day of the week by its order number
    func getNameOfDay(numberOfDay: Int) -> String{
        switch numberOfDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thur"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return ""
        }
    }
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 20.0)
                .fill(Color(red: 52/255, green: 235/255, blue: 137/255))
        
            VStack(alignment:.center, spacing: 10){
                Text("\(getNameOfDay(numberOfDay: (Calendar.current.component(.weekday, from: date))))")
                    .bold()
                
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 25))
                    .bold()
            }
        }
        .foregroundColor(.white)
    }
}


