//
//  CalendarImportView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 03.05.2021.
//

import SwiftUI
import EventKit
import CoreData

struct CalendarImportView: View {
    
    @State var allCalendars : [EKCalendar] = []
    @State var calendarNames : [String] = []
    @State var selectedCalendars : [String] = []
    @State var showCalendars = false
    @State var imported = false
    
    var context: NSManagedObjectContext
    
    func getCalendarTypes(){
        
        let store = EKEventStore()
        store.requestAccess(to: .event){granted, error in
        }
        
        allCalendars = store.calendars(for: .event)
        for cal in allCalendars{
            calendarNames.append(cal.title)
        }
    }
    
    func checkCalendars(calendar: EKCalendar) -> Bool{
        for cal in selectedCalendars {
            if cal == calendar.title {
                return true
            }
        }
        
        return false
    }
    
    func importCalendars(){
        let store = EKEventStore()
        store.requestAccess(to: .event){granted, error in
        }
        
        allCalendars.removeAll(where: {!checkCalendars(calendar: $0)})
        
        var thirtyDaysAgoComponents = DateComponents()
        thirtyDaysAgoComponents.day = -30
        let thirtyDaysAgo = Calendar.current.date(byAdding: thirtyDaysAgoComponents, to: Date())!
        
        let oneYearComponents = DateComponents()
        thirtyDaysAgoComponents.day = 365
        let oneYear = Calendar.current.date(byAdding: oneYearComponents, to: Date())!
        
        let predicate = store.predicateForEvents(withStart: thirtyDaysAgo , end: oneYear, calendars: allCalendars)
        
        var events : [EKEvent] = []
        events = store.events(matching: predicate)
        
        addEvents(fetchedEvents: events)
        
    }
    
    func addEvents(fetchedEvents: [EKEvent]){
        for event in fetchedEvents {
            var fetchRequest : FetchRequest<Task>
            fetchRequest = FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: true)],
                                        predicate: NSPredicate(format: "startDate == %@ && endDate == %@ && title == %@", event.startDate as NSDate, event.endDate as NSDate, event.title))
            
            if fetchRequest.wrappedValue.isEmpty {
                let newTask = Task(context: context)
                newTask.title = event.title
                newTask.note = event.notes
                newTask.startDate = event.startDate
                newTask.endDate = event.endDate
                newTask.status = event.endDate > Date() ? "New" : "Completed"
                newTask.tags = []
                
                try! context.save() // Trying to save current context.
            }
        }
        
        imported = true
    }
    
    var body: some View {
        VStack{
            Toggle(isOn: $showCalendars.animation()){
                Text("Синхронизировать с Календарём")
                    .font(.system(size: 18))
            }
            .padding()
            
            if showCalendars{
                ForEach(calendarNames, id: \.self){calendar in
                    CalendarImportOption(calendars: $selectedCalendars, title: calendar)
                }
                .padding()
                
                Button(action: {
                    imported = false
                    importCalendars()
                },
                label: {
                    Text("Импортировать")
                        .font(.system(size: 20))
                        .foregroundColor(imported ? .green : .blue)
                })
                
            }
            
            Spacer()
        }
        .onAppear(perform: getCalendarTypes)
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

