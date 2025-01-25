//
//  ContentView.swift
//  todo
//
//  Created by Apple on 2025/01/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct TodoItem: Identifiable, Codable {
    let id: String
    var title: String
    var isCompleted: Bool
    var dueDate: Date

    init(id: String = UUID().uuidString, title: String, isCompleted: Bool = false, dueDate: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}

class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    
    private var ref: DatabaseReference
    private var handle: DatabaseHandle?
    private var userID: String
    
    init(userID: String) {
        self.userID = userID
        ref = Database.database().reference(withPath: "todos/\(userID)")
        fetchData()
    }
    
    func updateUserID(userID: String) {
        if self.userID != userID {
            // 既存のオブザーバーが存在する場合は削除
            if let handle = handle {
                ref.removeObserver(withHandle: handle)
            }
            self.userID = userID
            ref = Database.database().reference(withPath: "todos/\(userID)")
            fetchData()
        }
    }
    
    deinit {
        if let handle = handle {
            ref.removeObserver(withHandle: handle)
        }
    }
    
    func fetchData() {
        handle = ref.observe(.value, with: { [weak self] snapshot in
            var newItems: [TodoItem] = []
            print("Snapshot received")
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let title = dict["title"] as? String {
                    
                    // isCompleted を Bool または Int から取得
                    var isCompleted = false
                    if let boolValue = dict["isCompleted"] as? Bool {
                        isCompleted = boolValue
                    } else if let intValue = dict["isCompleted"] as? Int {
                        isCompleted = intValue != 0
                    } else if let doubleValue = dict["isCompleted"] as? Double {
                        isCompleted = doubleValue != 0
                    }
                    
                    var timestamp: Double?
                    
                    // dueDate が Double 型の場合
                    if let doubleValue = dict["dueDate"] as? Double {
                        timestamp = doubleValue
                    }
                    // dueDate が String 型の場合
                    else if let stringValue = dict["dueDate"] as? String,
                            let doubleFromString = Double(stringValue) {
                        timestamp = doubleFromString
                    }
                    
                    if let timestamp = timestamp {
                        let dueDate = Date(timeIntervalSince1970: timestamp)
                        let item = TodoItem(id: childSnapshot.key, title: title, isCompleted: isCompleted, dueDate: dueDate)
                        
                        newItems.append(item)
                        print("newItems1 (after append): \(newItems)")
                    } else {
                        print("Invalid dueDate format for child: \(childSnapshot.key)")
                    }
                } else {
                    print("Failed to parse child: \(child)")
                }
            }
            
            DispatchQueue.main.async {
                print("DispatchQueue.main.async block is executing")
                print("newItems2 :\(newItems)")
                self?.items = newItems
            }
        })
    }


    
    func addItem(title: String, dueDate: Date) {
        let key = ref.childByAutoId().key ?? UUID().uuidString
        let newItem: [String : Any] = [
            "title": title,
            "isCompleted": false,
            "dueDate": dueDate.timeIntervalSince1970
        ]
        ref.child(key).setValue(newItem)
    }
    
    func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            let key = item.id
            ref.child(key).removeValue()
        }
    }
    
    func toggleCompletion(of item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let updatedStatus = !items[index].isCompleted
            items[index].isCompleted = updatedStatus
            let key = item.id
            ref.child(key).child("isCompleted").setValue(updatedStatus) // Bool 値として保存
        }
    }
}


struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    @StateObject private var todoViewModel: TodoViewModel
    
    init() {
        // Initialize with a dummy userID; it will be updated after authentication
        _todoViewModel = StateObject(wrappedValue: TodoViewModel(userID: ""))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    TodoListView(todoViewModel: todoViewModel)
                        .tabItem {
                            Label("Todo", systemImage: "checkmark.circle")
                        }
                    
                    CalendarView(todoViewModel: todoViewModel)
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }
                }
            }
            .navigationTitle("Todoアプリ")
        }
        .onAppear {
            if authManager.user == nil {
                authManager.anonymousSignIn {
                    // Update the userID in TodoViewModel after signing in
                    if let userID = authManager.currentUserId {
                        todoViewModel.updateUserID(userID: userID)
                    }
                }
            } else {
                if let userID = authManager.currentUserId {
                    todoViewModel.updateUserID(userID: userID)
                }
            }
        }
    }
}

struct TodoListView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @State private var newTodoTitle: String = ""
    @State private var postFlag = false
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(todoViewModel.items) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    todoViewModel.toggleCompletion(of: item)
                                }
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .strikethrough(item.isCompleted, color: .black)
                                    .foregroundColor(item.isCompleted ? .gray : .black)
                                Text("期限: \(formattedDate(item.dueDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: todoViewModel.removeItems)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        postFlag = true
                        guard !newTodoTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .padding(20)
                            .background(Color.black)
                            .foregroundColor(Color.white)
                            .clipShape(Circle())
                    }
                    .shadow(radius: 3)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $postFlag) {
            AddPostView(text: $newTodoTitle, todoViewModel: todoViewModel)
                .presentationDetents([.large,
                                      .height(200),
                                      .fraction(isSmallDevice() ? 0.65 : 0.55)
                ])
        }
        .navigationTitle("Todoリスト")
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
}

struct AddPostView: View {
    @Binding var text: String
    @ObservedObject var todoViewModel: TodoViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack{
                Rectangle()
                    .frame(width:5,height: 20)
                    .foregroundColor(Color.black)
                Text("TODOを追加する")
                    .font(.headline)
                Spacer()
            }
            TextField("新しいタスクを入力", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 18))
            
            DatePicker("期限日", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(.horizontal)
            
            Divider()
            
            Button(action: {
                let trimmedTitle = text.trimmingCharacters(in: .whitespaces)
                guard !trimmedTitle.isEmpty else { return }
                todoViewModel.addItem(title: trimmedTitle, dueDate: selectedDate)
                text = ""
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("追加")
                    .fontWeight(.bold)
                    .frame(maxWidth:.infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .shadow(radius: 1)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct CalendarView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        VStack {
            // Header: Month Navigation
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                }
                Spacer()
                Text(monthYearFormatter.string(from: currentDate))
                    .font(.headline)
                Spacer()
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                        .padding()
                }
            }
            
            // Weekday Labels
            let days = Calendar.current.shortWeekdaySymbols
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Date Grid
            let daysInMonth = generateDaysInMonth(for: currentDate)
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        let hasTodo = todoViewModel.items.contains { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
                        
                        Button(action: {
                            selectedDate = date
                        }) {
                            VStack {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .foregroundColor(Calendar.current.isDate(date, inSameDayAs: Date()) ? .red : .primary)
                                    .fontWeight(Calendar.current.isDate(date, inSameDayAs: Date()) ? .bold : .regular)
                                if hasTodo {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .padding(8)
                            .background(
                                Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date()) ?
                                Color.blue.opacity(0.3) :
                                Color.clear
                            )
                            .cornerRadius(8)
                        }
                    } else {
                        // Empty Cell for Placeholder Dates
                        Text("")
                            .padding(8)
                    }
                }
            }
            .padding()
            
            // Selected Date's Todo List
            if let selectedDate = selectedDate {
                Divider()
                Text("選択された日: \(fullDateFormatter.string(from: selectedDate))")
                    .font(.headline)
                    .padding(.top)
                
                List {
                    let filteredTodos = todoViewModel.items.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
                    if filteredTodos.isEmpty {
                        Text("この日にTodoはありません")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredTodos) { item in
                            HStack {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        todoViewModel.toggleCompletion(of: item)
                                    }
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .strikethrough(item.isCompleted, color: .black)
                                        .foregroundColor(item.isCompleted ? .gray : .black)
                                    Text("期限: \(formattedDate(item.dueDate))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete { indices in
                            let todosToRemove = indices.map { filteredTodos[$0] }
                            for todo in todosToRemove {
                                if let index = todoViewModel.items.firstIndex(where: { $0.id == todo.id }) {
                                    todoViewModel.removeItems(at: IndexSet(integer: index))
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle("カレンダー")
    }
    
    // Month and Year Formatter
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 MMMM"
        return formatter
    }
    
    // Full Date Formatter
    private var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    // Date Formatter for Todo Items
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Generate Days for the Current Month with Placeholders
    private func generateDaysInMonth(for date: Date) -> [Date?] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: date) else { return [] }
        var dates: [Date?] = []
        
        let firstWeekday = Calendar.current.component(.weekday, from: monthInterval.start)
        // Adjust for firstWeekday starting from 1 (Sunday)
        for _ in 1..<firstWeekday {
            dates.append(nil) // Placeholder for empty cells
        }
        
        var current = monthInterval.start
        while current < monthInterval.end {
            dates.append(current)
            guard let next = Calendar.current.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        
        return dates
    }
}


#Preview {
    ContentView()
}
