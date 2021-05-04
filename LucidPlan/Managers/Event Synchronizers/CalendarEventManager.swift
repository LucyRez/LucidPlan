//
//  CalendarEventManager.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 04.05.2021.
//

import Foundation
import EventKit
import CoreData

class CalendarEventManager: ObservableObject{
    
    @Published var allCalendars : [EKCalendar] = []
    @Published var calendarNames : [String] = []
    @Published var selectedCalendars : [String] = []
    @Published var imported = false
    
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
    
    func importCalendars(context: NSManagedObjectContext){
        let store = EKEventStore()
        store.requestAccess(to: .event){granted, error in
        }
        
        allCalendars.removeAll(where: {!checkCalendars(calendar: $0)})
        
        var thirtyDaysAgoComponents = DateComponents()
        thirtyDaysAgoComponents.day = -30
        let thirtyDaysAgo = Calendar.current.date(byAdding: thirtyDaysAgoComponents, to: Date())!
        
        var oneYearComponents = DateComponents()
        oneYearComponents.day = 365
        let oneYear = Calendar.current.date(byAdding: oneYearComponents, to: Date())!
        
        let predicate = store.predicateForEvents(withStart: thirtyDaysAgo , end: oneYear, calendars: allCalendars)
        
        var events : [EKEvent] = []
        events = store.events(matching: predicate)
        
        addEvents(fetchedEvents: events, context: context)
        
    }
    
    func addEvents(fetchedEvents: [EKEvent], context: NSManagedObjectContext){
        for event in fetchedEvents {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
            fetchRequest.predicate = NSPredicate(format: "title == %@", event.title as String)
            fetchRequest.predicate = NSPredicate(format: " startDate == %@", event.startDate as NSDate)
            
            do{
                let count = try context.count(for: fetchRequest)
                
                if count == 0 {
                    let newTask = Task(context: context)
                    newTask.title = event.title
                    newTask.note = event.notes
                    newTask.startDate = event.startDate
                    newTask.endDate = event.endDate
                    newTask.status = event.endDate > Date() ? "New" : "Completed"
                    newTask.tags = []
                    
                    try! context.save() // Trying to save current context.
                }
                
            }catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        imported = true
    }
    
}
