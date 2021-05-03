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
                Image(systemName: "plus.circle.fill").accentColor(Color( red: 17/255, green: 141/255, blue: 211/255))
                    .font(.system(size: 40))
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
    let isSelected : Bool
    
    init(date: Date, isSelected: Bool){
        self.date = date
        self.isSelected = isSelected
    }
    
    func numberOfDays(between startDay: Date, and endDate: Date) -> Int{
        
        let number = Calendar.current.dateComponents([.day], from: startDay, to: endDate)
        
        return number.day!
    }
    
    // Function gets name of the day of the week by its order number
    func getNameOfDay(numberOfDay: Int) -> String{
        switch numberOfDay {
        case 1:
            return "Вс"
        case 2:
            return "Пн"
        case 3:
            return "Вт"
        case 4:
            return "Ср"
        case 5:
            return "Чт"
        case 6:
            return "Пт"
        case 7:
            return "Сб"
        default:
            return ""
        }
    }
    
    var body: some View{
        ZStack{
            
            if (numberOfDays(between: Calendar.current.startOfDay(for: date), and: Calendar.current.startOfDay(for: Date()))==0) && !isSelected{
            RoundedRectangle(cornerRadius: 20.0)
                .stroke(Color(red: 26/255, green: 231/255, blue: 202/255), lineWidth: 3)
                .padding(1)
                
            }else if isSelected{
                RoundedRectangle(cornerRadius: 20.0)
                .fill(Color(red: 26/255, green: 231/255, blue: 202/255))
            }else{
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color.white)
            }
                
            VStack(alignment:.center, spacing: 10){
                Text("\(getNameOfDay(numberOfDay: (Calendar.current.component(.weekday, from: date))))")
                    .font(.system(size: 24))
                    .bold()
                    .foregroundColor(isSelected ? .white : .black)
                    .opacity(isSelected ? 1 : 0.3)
                
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 25))
                    .bold()
                    .foregroundColor(isSelected ? .white : .black)
                   
            }
            
           
        }
       
    }
}


