//
//  AddTaskView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 28.03.2021.
//

import Foundation
import SwiftUI

struct AddTaskView: View {
    @ObservedObject var task : TaskViewModel
    @Environment(\.managedObjectContext) var context
    
    
    init(task:TaskViewModel){
        UITextView.appearance().backgroundColor = .clear
        self.task = task
    }
    
    var body: some View{
        
        VStack{
            Text("\(task.task != nil ? "Update" : "Create New") Task")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding()
            
            TextField("Enter the title", text: $task.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            
            
            TextEditor(text:$task.note )
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal,10)
            
            AddTagView(model: task)
            
            Divider()
                .padding(.horizontal)
            
            HStack{
                Text("When")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
            }
            .padding()
            
            HStack{
                Text("Start Time ")
                    .font(.title)
                    .foregroundColor(.black)
                
                Spacer()
                
                DatePicker("", selection: $task.startDate)
                    .labelsHidden()
                    .accentColor(.black)
            }
            .padding()
            
            
            HStack{
                Text("End Time")
                    .font(.title)
                    .foregroundColor(.black)
                
                Spacer()
                
                DatePicker("", selection: $task.endDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .accentColor(.black)
            }
            .padding()
            
            HStack{
                DateButton(task: task, title: "Today")
                DateButton(task: task, title: "Tomorrow")
                Spacer()
            }
            .padding()
            
            
            Button(action: {
                task.writeData(context: context)
                
            }, label: {
                Label(
                    title: {
                        Text("\(task.task == nil ? "Add Task" : "Edit Task")")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                        
                    },
                    icon: {
                        Image(systemName: "\(task.task == nil ? "plus" : "")")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                    })
                    .frame(width: UIScreen.main.bounds.width-30)
                    .padding(.vertical)
                    .background(
                        LinearGradient(gradient: .init(colors: [Color(red: 121/255, green: 220/255, blue: 199/255), Color(red: 168/255, green: 226/255, blue: 201/255)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(8)
            })
            .padding()
            .disabled(task.title == "" && task.endDate < task.startDate ? true : false)
            
            
            
        }
        .padding()
        .background(Color.black.opacity(0.01)).ignoresSafeArea(.all, edges: .bottom)
        .onDisappear(perform: {
            task.task = nil
            task.note = ""
            task.title = ""
        })
        
    }
    
}

struct DateButton: View{
    @ObservedObject var task : TaskViewModel
    var title : String
    
    func checkDate() -> String{
        if Calendar.current.isDateInToday(task.startDate) {
            return "Today"
        }else if Calendar.current.isDateInTomorrow(task.startDate){
            return "Tomorrow"
        }
        return "Other"
    }
    
    func updateStartDate(){
        if title == "Today"{
            task.startDate = Date()
        }else if title == "Tomorrow"{
            task.startDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        }else{
            
        }
    }
    
    var body: some View{
        Button(action: {
            updateStartDate()
        }
        , label: {
            Text(title)
                .bold()
                .foregroundColor(checkDate() == title ? .white : .gray)
                .padding()
                .background(
                    checkDate() == title ?
                        LinearGradient(gradient: .init(colors: [Color(red: 121/255, green: 220/255, blue: 199/255), Color(red: 168/255, green: 226/255, blue: 201/255)]), startPoint: .leading, endPoint: .trailing)
                        :  LinearGradient(gradient: .init(colors: [Color(.white)]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(6)
        })
        
    }
    
}

struct AddTagView: View{
    var task : TaskViewModel
    @State var tagString : String = ""
    @State var addedTags : [String] = []
    
    init(model: TaskViewModel){
        task = model
    }
    
    var body: some View{
        VStack{
            HStack{
                Text("Added Tags: ")
                    .font(.system(size: 25))
                    .padding(.horizontal)
                
                 Spacer()
                
                ForEach(addedTags, id: \.self){tag in
                    Text(tag)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Capsule().stroke(Color.black, lineWidth: 1))
                }
            }
        
        HStack{
            TextField("Write a tag here", text: $tagString)
                .padding()
                .frame(width: 350, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.white)
                .cornerRadius(10)
                .padding(5)
            Button(action: {
                task.addTag(tag: tagString)
                addedTags.append(tagString)
                tagString = ""
            }, label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.green)
                    .font(.system(size: 28))
                
            })
        }
        }
        
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(task: TaskViewModel())
    }
}
