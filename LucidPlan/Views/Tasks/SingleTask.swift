//
//  SingleTask.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.04.2021.
//

import Foundation
import SwiftUI
import CoreData

/**
 This view represents a single task.
 */
struct SingleTaskView: View{
    
    var startDate : String
    var endDate : String
    var title : String
    var notes : String
    var tags : [String]
    var status : String
    var model : TaskViewModel // Task manager
    var task : Task // Current task
    var passed : Bool
    @Environment(\.managedObjectContext) var context // Current context
    
    init(task: Task, model: TaskViewModel){
        let startTime = Calendar.current.dateComponents([.hour, .minute], from: task.startDate!)
        let endTime = Calendar.current.dateComponents([.hour, .minute], from: task.endDate!)
        let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
        if endTime.minute! < now.minute!{
            if endTime.hour! <= now.hour!{
                passed = true
            }else{
                passed = false
            }
        }else {
            if endTime.hour! < now.hour!{
                passed = true
            }else{
                passed = false
            }
        }
        
        let start = "\(startTime.hour!) : \(startTime.minute!)"
        let end = "\(endTime.hour!) : \(endTime.minute!)"
        self.model = model
        self.task = task
        startDate = start
        endDate = end
        self.title = task.title!
        self.notes = task.note ?? ""
        self.tags = task.tags!
        self.status = task.status!
    }
    
    let layout = [GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible())]
    
    var body: some View{
        HStack(alignment:.top, spacing:30){
            // Show start time and end time
            VStack(spacing:5){
                Text(startDate)
                Text(endDate)
                    .opacity(0.5)
            }
            
            ZStack(alignment:.topLeading){
                RoundedRectangle(cornerRadius: 10)
                    .fill(!passed ? Color( red: 157/255, green: 214/255, blue: 146/255) : Color.gray.opacity(0.2))
                    .frame(width: .infinity, height: 150)
                
                VStack{
                    HStack(alignment: .top){
                        Text(title)
                            .bold()
                            .shadow(radius: 0.1)
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(passed ? Color.black.opacity(0.3) : .white)
                        
                        Spacer()
                        
                        Menu{
                            
                            Button(action: {self.model.editData(task: task)},
                                   label: {
                                    HStack{
                                        Image(systemName: "square.and.pencil")
                                        Text("Редактировать")
                                    }
                                   
                                   })
                            
                            Button(action: {
                                context.delete(task)
                                try! context.save() //TODO: MOVE THIS TO THE MANAGER
                                
                            }, label: {
                                HStack{
                                    Image(systemName: "trash")
                                    Text("Удалить")
                                }
                            })
                        }
                        label: {
                            Text(":")
                                .bold()
                                .font(.system(size: 40))
                                .padding(.trailing)
                        }
                    }
                    .foregroundColor(.white)
                    
                    // Show tags
                    LazyVGrid(columns: layout, spacing: 2){
                        ForEach(tags, id: \.self){tag in
                            Text(tag)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Capsule().stroke(Color.white, lineWidth: 1))
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        
    }
}
