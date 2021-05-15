//
//  MainTasksView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.04.2021.
//

import Foundation
import SwiftUI


/**
 Main view for showing tasks.
 Contains every part of the view.
 */
struct ScheduleView: View{
    @State var dateArray : [Date] = [] // Array of dates that are shown on the top scroll view
    @StateObject var model : TaskViewModel = TaskViewModel() // Task Manager is created here
    @State var currentDate : Date = Calendar.current.startOfDay(for: Date()) // Today's date
    @State var changeRepresentation : Bool = true // Shows if we want to change the layout (scroll view or calendar)
    
    var rows = [ GridItem()]
    
    // TODO: THINK OF HOW WE CAN DYNAMICALLY UPDATE THESE DATES
    // Function is used to update dates for scroll view
    func updateDateArray(){
        
        var dates : [Date] = []
        var previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) // Previous dates (1 month) from today
        let futureMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) // Future dates (1 month) from today
        
        // Then we add dates to the array
        while(previousMonth!<=futureMonth!){
            previousMonth = Calendar.current.date(byAdding: .day, value: 1, to: previousMonth!)
            dates.append(previousMonth!)
        }
        
        dateArray = dates
    }
    
   
    
    var body: some View{
        
        VStack(alignment:.center){
            HStack{
                TopTaskView(model: model)
                
                // In this HStack are 2 buttons to change the layout
                HStack(spacing: -34){
                    Button(action: {
                        changeRepresentation = true
                    },
                    label: {
                        Text("Неделя")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 11)
                            .padding(.leading, 18)
                            .padding(.trailing, 15)
                            .background(Color(red: 255/255, green: 214/255, blue: 165/255))
                            //.background(Color(red: 121/255, green: 220/255, blue: 199/255))
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .font(.system(size: 18))
                    }).zIndex(1)
                    
                    
                    Button(action: {
                        changeRepresentation = false
                    },
                    label: {
                        Text("Месяц")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 11)
                            .padding(.leading, 33)
                            .padding(.trailing, 15)
                            .background(Color(red: 255/255, green: 202/255, blue: 138/255))
                            //.background(Color(red: 168/255, green: 226/255, blue: 201/255))
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .font(.system(size: 18))
                    }).zIndex(0)
                }
                
            }
            .padding(.horizontal,10)
            
            // Show scroll view or calendar
            if(changeRepresentation){
                ScrollView(.horizontal, showsIndicators: false){
                    ScrollViewReader {val in
                        LazyHGrid(rows: rows){
                            ForEach(self.dateArray, id: \.self ){date in
                                DateView(date: date, isSelected: currentDate == date)
                                    .frame(width: 65, height: 100)
                                    .onTapGesture {
                                        currentDate = date
                                        
                                    }
                                  
                            }
                        }
                        .onAppear(perform: updateDateArray) // We are updating the dates
                        .onAppear(perform: {
                            DispatchQueue.main.async {
                                val.scrollTo(dateArray[(dateArray.endIndex)/2-1], anchor: .bottom) // Auto scroll to the middle
                            }
                        })
                        .onChange(of: currentDate, perform: { value in
                            updateDateArray()
                            
                            DispatchQueue.main.async {
                                val.scrollTo(dateArray[(dateArray.lastIndex(of: currentDate)!)], anchor: .bottom)
                            }
                           
                        })
                        
                    }
                    .padding()
                }
                .frame(width: UIScreen.main.bounds.width, height: 100)
                
            }else{
                
                DatePicker("", selection: $currentDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.bottom, -30)
                
                
            }
            
            TasksView(filter: currentDate, model: model) // Show container with the tasks
        }
    }
}
