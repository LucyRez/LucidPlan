//
//  CalendarImportView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 03.05.2021.
//

import SwiftUI

struct CalendarImportView: View {
    
    @State var showCalendars = false
    @StateObject var eventManager = CalendarEventManager()
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack{
            Toggle(isOn: $showCalendars.animation()){
                Text("Синхронизировать с Календарём")
                    .font(.system(size: 18))
            }
            .padding()
            
            if showCalendars{
                ForEach(eventManager.calendarNames, id: \.self){calendar in
                    CalendarImportOption(calendars: $eventManager.selectedCalendars, title: calendar)
                }
                .padding()
                
                Button(action: {
                    eventManager.imported = false
                    eventManager.importCalendars(context: context)
                },
                label: {
                    Text("Импортировать")
                        .font(.system(size: 20))
                        .foregroundColor(eventManager.imported ? .green : .blue)
                })
                
            }
            
            Spacer()
        }
        .onAppear(perform: eventManager.getCalendarTypes)
    }
}

struct CalendarImportOption: View{
    @State var selected : Bool = false
    @Binding var calendars : [String]
    
    var title : String
    
    var body: some View{
        VStack{
            HStack{
                Text(title)
                    .font(.system(size: 17))
                    .padding()
                Spacer()
                
                if selected{
                    Image(systemName: "circle.fill")
                    
                }else{
                    Image(systemName: "circle")
                    
                }
            }
            
        }
        .onTapGesture {
            if selected{
                calendars.removeAll(where: {$0 == title})
                selected.toggle()
            }else{
                calendars.append(title)
                selected.toggle()
            }
        }
    }
}

