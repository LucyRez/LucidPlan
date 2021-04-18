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
    @State var currentDate : Date = Date() // Today's date
    @State var changeRepresentation : Bool = true // Shows if we want to change the layout (scroll view or calendar)
    
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
        
        VStack{
            HStack{
                TopTaskView(model: model)
                
                // In this HStack are 2 buttons to change the layout
                HStack(spacing: -35){
                    Button(action: {
                        changeRepresentation.toggle()
                    },
                    label: {
                        Text("Неделя")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 11)
                            .padding(.horizontal, 18)
                            .background(Color(red: 81/255, green: 252/255, blue: 198/255))
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .font(.system(size: 18))
                    }).zIndex(1)
                    
                    
                    Button(action: {
                        changeRepresentation.toggle()
                    },
                    label: {
                        Text("Месяц")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 11)
                            .padding(.leading, 40)
                            .padding(.trailing, 15)
                            .background(Color.green.opacity(0.5))
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
                        HStack(spacing:-15){
                            ForEach(self.dateArray, id: \.self ){date in
                                HStack{
                                    DateView(date: date)
                                        .frame(width: 70, height: 100)
                                        .padding()
                                        .onTapGesture{
                                            currentDate = date // We show the info about date by taping on it
                                        }
                                }
                            }
                        }
                        .onAppear(perform: updateDateArray) // We are updating the dates
                        .onAppear(perform: {
                            DispatchQueue.main.async {
                                val.scrollTo(dateArray[(dateArray.endIndex)/2-2], anchor: .bottom) // Авто скролл к концу массива дат.
                            }
                        }); // Auto scroll to the middle
                    }
                    .padding()
                }
                .frame(width: .infinity, height: 100)
                
            }else{
                DatePicker("", selection: $currentDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            
            TasksView(filter: currentDate, model: model) // Show container with the tasks
        }
    }
}
