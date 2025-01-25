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
    
    deinit {
        if let handle = handle {
            ref.removeObserver(withHandle: handle)
        }
    }
    
    func fetchData() {
        handle = ref.observe(.value, with: { [weak self] snapshot in
            var newItems: [TodoItem] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let title = dict["title"] as? String,
                   let isCompleted = dict["isCompleted"] as? Bool,
                   let timestamp = dict["dueDate"] as? Double {
                    let dueDate = Date(timeIntervalSince1970: timestamp)
                    let item = TodoItem(id: childSnapshot.key, title: title, isCompleted: isCompleted, dueDate: dueDate)
                    newItems.append(item)
                }
            }
            DispatchQueue.main.async {
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
            ref.child(key).child("isCompleted").setValue(updatedStatus)
        }
    }
}


struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = authManager.user {
                    TodoListView(userID: user.uid)
                } else {
                    AuthManagerView(authManager: authManager)
                }
            }
        }
        .onAppear {
            if authManager.user == nil {
                authManager.anonymousSignIn {}
            }
        }
    }
}

struct TodoListView: View {
    
    @StateObject private var todoViewModel: TodoViewModel
    @State private var newTodoTitle: String = "test"
    @State private var postFlag = false
    
    init(userID: String) {
        _todoViewModel = StateObject(wrappedValue: TodoViewModel(userID: userID))
    }
    
    var body: some View {
        ZStack{
            VStack {
                
                List {
                    ForEach(todoViewModel.items) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    todoViewModel.toggleCompletion(of: item)
                                }
                            Text(item.title)
                                .strikethrough(item.isCompleted, color: .black)
                                .foregroundColor(item.isCompleted ? .gray : .black)
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
//                        todoViewModel.addItem(title: newTodoTitle)
//                        newTodoTitle = ""
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
                                      // 画面に対する割合
                    .fraction(isSmallDevice() ? 0.65 : 0.55)
                ])
        }
        .toolbar {
            EditButton()
        }
    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
}

struct CalendarView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @State private var selectedDate: Date = Date()
    
    // Helper to group todos by date
    var groupedTodos: [Date: [TodoItem]] {
        Dictionary(
            grouping: todoViewModel.items,
            by: { Calendar.current.startOfDay(for: $0.dueDate) }
        )
    }
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            List {
                if let todos = groupedTodos[Calendar.current.startOfDay(for: selectedDate)] {
                    ForEach(todos) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    todoViewModel.toggleCompletion(of: item)
                                }
                            Text(item.title)
                                .strikethrough(item.isCompleted, color: .black)
                                .foregroundColor(item.isCompleted ? .gray : .black)
                        }
                    }
                    .onDelete { offsets in
                        let items = offsets.map { todos[$0] }
                        items.forEach { item in
                            if let index = todoViewModel.items.firstIndex(where: { $0.id == item.id }) {
                                todoViewModel.removeItems(at: IndexSet(integer: index))
                            }
                        }
                    }
                } else {
                    Text("No todos for this date.")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("カレンダー")
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


struct AuthManagerView: View {
    @ObservedObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            if authManager.user == nil {
                Text("ログインしていません")
                Button(action: {
                    authManager.anonymousSignIn {}
                }) {
                    Text("匿名でログイン")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Text("ユーザーID: \(authManager.user!.uid)")
            }
        }
    }
}

#Preview {
    ContentView()
}
