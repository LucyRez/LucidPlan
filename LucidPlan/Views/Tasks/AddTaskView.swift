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
            Text("\(task.task != nil ? "Изменить " : "Создать ") событие")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding()
            
            TextField("Введите название... ", text: $task.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            
            TextField("Место для заметок...", text: $task.note)
                .font(.system(size: 18))
                .cornerRadius(20)
                .padding(15)
                .background(Color.gray.opacity(0.1))
                
            
            AddTagView(model: task)
                .padding(.vertical)
            
            Toggle(isOn: $task.isDeadline, label: {
                Text("Дедлайн")
                    .font(.system(size: 18))
            })
            .padding(.horizontal)
            
            
            HStack{
                Text("Когда")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
            }
            .padding()
            
            HStack{
                Text("Начало:")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                DatePicker("", selection: $task.startDate)
                    .labelsHidden()
                    .accentColor(.black)
            }
            .padding(.horizontal)
            
            
            HStack{
                Text("Конец:")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                DatePicker("", selection: $task.endDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .accentColor(.black)
            }
            .padding(.horizontal)
            
            HStack{
                DateButton(task: task, title: "Сегодня")
                DateButton(task: task, title: "Завтра")
                Spacer()
            }
            .padding()
            
            
            Button(action: {
                task.writeData(context: context)
                
            }, label: {
                Label(
                    title: {
                        Text("\(task.task == nil ? "Добавить событие" : "Изменить событие")")
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
                        LinearGradient(gradient: .init(colors: [Color(red: 255/255, green: 173/255, blue: 173/255), Color(red: 255/255, green: 214/255, blue: 165/255)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(8)
            })
            .padding()
            .disabled(task.title == "" && task.endDate < task.startDate ? true : false)
            
            
            
        }
        .padding()
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
            return "Сегодня"
        }else if Calendar.current.isDateInTomorrow(task.startDate){
            return "Завтра"
        }
        return "Другое"
    }
    
    func updateStartDate(){
        if title == "Сегодня"{
            task.startDate = Date()
        }else if title == "Завтра"{
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
                        LinearGradient(gradient: .init(colors: [Color(red: 255/255, green: 173/255, blue: 173/255),  Color(red: 255/255, green: 214/255, blue: 165/255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        :  LinearGradient(gradient: .init(colors: [Color(.white)]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(6)
        })
        
    }
    
}

struct AddTagView: View{
    var task : TaskManager
    @State var tagString : String = ""
    @State var addedTags : [String] = []
    
    init(model: TaskManager){
        task = model
    }
    
    var body: some View{
        VStack{
            HStack{
                Text("Добавленные теги: ")
                    .font(.system(size: 20))
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
                TextField("Введите название тега...", text: $tagString)
                    .font(.system(size: 18))
                    .padding()
                    .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(5)
                Button(action: {
                    if  !tagString.isEmpty && addedTags.count < 3{
                        task.addTag(tag: tagString)
                        addedTags.append(tagString)
                        tagString = ""
                    }
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                        .font(.system(size: 28))
                    
                })
                .padding(.horizontal)
            }
        }
        
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(task: TaskViewModel())
    }
}
