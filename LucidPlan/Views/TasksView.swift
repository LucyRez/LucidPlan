//
//  TasksView.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 18.03.2021.
//

import SwiftUI
import CoreData

struct ScheduleView: View{
    @State var dateArray : [Date] = []
    @StateObject var model : TaskViewModel = TaskViewModel()
    @State var currentDate : Date = Date()
    @State var changeRepresentation : Bool = true
    
    func updateDateArray(){
        
        
        var dates : [Date] = []
        var previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        let futureMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        
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
                                            currentDate = date
                                        }
                                    
                                }.id(date)
                            }
                        }
                        .onAppear(perform: updateDateArray)
                        .onAppear(perform: {
                            DispatchQueue.main.async {
                                val.scrollTo(dateArray[(dateArray.endIndex)/2-2], anchor: .bottom) // Авто скролл к концу массива дат.
                            }
                        });
                        
                    }
                    .padding()
                    
                }
                .frame(width: .infinity, height: 100)
                
            }else{
                DatePicker("", selection: $currentDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            
            TasksView(filter: currentDate, model: model)
        }
    }
    
}

struct TasksView: View {
    
    var model : TaskViewModel
    
    var fetchRequest : FetchRequest<Task>
    
    var tasks : FetchedResults<Task>{
        fetchRequest.wrappedValue
    }
    
    
    init(filter: Date, model: TaskViewModel){
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
                    .foregroundColor(.gray)
                
                Text("Задача")
                    .bold()
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "list.bullet")
                    .opacity(0.7)
            }
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

struct SingleTaskView: View{
    
    var startDate : String
    var endDate : String
    var title : String
    var notes : String
    var tags : [String]
    var status : String
    var model : TaskViewModel
    var task : Task
    @Environment(\.managedObjectContext) var context
    
    init(task: Task, model: TaskViewModel){
        let startTime = Calendar.current.dateComponents([.hour, .minute], from: task.startDate!)
        let endTime = Calendar.current.dateComponents([.hour, .minute], from: task.endDate!)
        let start = "\(startTime.hour!) : \(startTime.minute!)"
        let end = "\(endTime.hour!) : \(endTime.minute!)"
        self.model = model
        self.task = task
        startDate = start
        endDate = end
        self.title = task.title!
        self.notes = task.note!
        self.tags = task.tags!
        self.status = task.status!
    }
    
    var body: some View{
        HStack(alignment:.top, spacing:30){
            VStack(spacing:5){
                Text(startDate)
                
                Text(endDate)
                    .opacity(0.5)
            }
            
            ZStack(alignment:.topLeading){
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color( red: 16/255, green: 230/255, blue: 162/255))
                    .frame(width: .infinity, height: 150)
                VStack{
                    HStack{
                        Text(title)
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding()
                        
                        Spacer()
                        Text(":")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 40))
                            .padding(.trailing)
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: {self.model.editData(task: task)}, label: {
                                    Text("Edit")
                                })
                                Button(action: {
                                    context.delete(task)
                                    try! context.save()
                                    
                                }, label: {
                                    Text("Delete")
                                })
                            }))
                    }
                    HStack{
                        ForEach(tags, id: \.self){tag in
                            Text(tag)
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Capsule().stroke(Color.gray, lineWidth: 1))
                            
                        }
                        .padding(.leading,5)
                        
                        Spacer()
                    }
                }
            }
        }
        
    }
}


struct TopTaskView: View{
    @StateObject var model : TaskViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View{
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

struct TabBarView: View{
    @StateObject var socketManager : SocketIOManager = SocketIOManager() // Создаём сокет-менеджер.
    let tabBarImages : [String] = ["calendar","clock", "note.text", "person.2"]
    @State var viewIndex : Int = 0
    var body: some View{
        VStack{
            ZStack{
                switch viewIndex{
                case 0:
                    ScheduleView()
                case 1:
                    DeadlineView()
                case 2:
                    ToDoView()
                default:
                    ChatScreen(socketManager: socketManager)
                }
                
            }
            Spacer()
            
            HStack{
                ForEach(0..<4){number in
                    Button(action: {
                        viewIndex = number
                    }, label: {
                        Spacer()
                        Image(systemName: tabBarImages[number])
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black).opacity(viewIndex == number ? 1 : 0.3)
                        Spacer()
                    })
                    
                }
            }
        }
    }
}


struct DateView: View{
    
    let date : Date
    
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
                    .foregroundColor(.white)
                    .bold()
                
                Text("\(Calendar.current.component(.day, from: date))")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .bold()
                
                
            }
        }
    }
    
    
}


