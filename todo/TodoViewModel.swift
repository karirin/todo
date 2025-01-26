//
//  TodoViewModel.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI
import Firebase

struct TodoItem: Identifiable, Codable, Equatable {
    let id: String
    var title: String
    var isCompleted: Bool
    var dueDate: Date
    var order: Int // 並び順を管理するフィールドを追加

    init(id: String = UUID().uuidString, title: String, isCompleted: Bool = false, dueDate: Date = Date(), order: Int = 0) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.order = order
    }
}

// MARK: - TodoViewModel
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
            guard let self = self else { return }
            var newItems: [TodoItem] = []
            
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
                    
                    // order を Int 型として取得
                    let order = dict["order"] as? Int ?? 0
                    
                    if let timestamp = timestamp {
                        let dueDate = Date(timeIntervalSince1970: timestamp)
                        let item = TodoItem(id: childSnapshot.key, title: title, isCompleted: isCompleted, dueDate: dueDate, order: order)
                        
                        newItems.append(item)
                    } else {
                    }
                } else {
                }
            }
            
            // order に基づいてソート
            newItems.sort { $0.order < $1.order }
            
            DispatchQueue.main.async {
                self.items = newItems
            }
        })
    }

    func addItem(title: String, dueDate: Date) {
        let key = ref.childByAutoId().key ?? UUID().uuidString
        let newOrder = (items.map { $0.order }.max() ?? 0) + 1
        let newItem: [String : Any] = [
            "title": title,
            "isCompleted": false,
            "dueDate": dueDate.timeIntervalSince1970,
            "order": newOrder
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
    
    func removeItem(_ item: TodoItem) {
        let key = item.id
        ref.child(key).removeValue()
    }
    
    func toggleCompletion(of item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let updatedStatus = !items[index].isCompleted
            items[index].isCompleted = updatedStatus
            let key = item.id
            ref.child(key).child("isCompleted").setValue(updatedStatus) // Bool 値として保存
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        var revisedItems = items
        revisedItems.move(fromOffsets: source, toOffset: destination)
        items = revisedItems
        
        // order を更新して Firebase に反映
        for (index, item) in items.enumerated() {
            let key = item.id
            ref.child(key).child("order").setValue(index)
        }
    }
    
    // 並び替え用のカスタム関数
    func reorderItems(draggingItem: TodoItem, to newIndex: Int) {
        guard let currentIndex = items.firstIndex(where: { $0.id == draggingItem.id }) else { return }
        let item = items.remove(at: currentIndex)
        items.insert(item, at: newIndex)
        moveItem(from: IndexSet(integer: currentIndex), to: newIndex)
    }
}
