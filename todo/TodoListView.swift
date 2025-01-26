//
//  TodoListView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

// MARK: - TodoRowView
struct TodoRowView: View {
    let item: TodoItem
    @Binding var draggingItem: TodoItem?
    @Binding var dragOffset: CGSize
    @ObservedObject var todoViewModel: TodoViewModel
    @State private var showingAlert = false
    @State private var isDragging: Bool = false
    @State private var originalOrder: Int = 0
    
    var body: some View {
        HStack {
            // チェックボタン
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isCompleted ? .green : .gray)
                .onTapGesture {
                    todoViewModel.toggleCompletion(of: item)
                }
                .padding(.trailing, 10)
            
            // タイトルと期限日
            HStack{
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(.system(size: 20))
                        .strikethrough(item.isCompleted, color: .black)
                        .foregroundColor(item.isCompleted ? .gray : .black)
                    HStack {
                        Image(systemName: "calendar.circle")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.trailing, -5)
                        Text("\(formattedDate(item.dueDate))")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                todoViewModel.toggleCompletion(of: item)
            }
            Button(action: {
                showingAlert = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .padding(.trailing, 10)
            // ドラッグハンドル
            //        Image(systemName: "line.horizontal.3")
            //            .foregroundColor(.gray)
            //            .padding(.leading, 10)
            //            .gesture(
            //                LongPressGesture(minimumDuration: 0.2)
            //                    .onEnded { _ in
            //                        withAnimation {
            //                            self.draggingItem = item
            //                            self.originalOrder = todoViewModel.items.firstIndex(where: { $0.id == item.id }) ?? 0
            //                        }
            //                    }
            //            )
        }
        .padding()
        .background(
            isDragging ? Color.blue.opacity(0.2) : Color.white
        )
        .cornerRadius(8)
        .shadow(color: isDragging ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2), radius: 5, x: 0, y: isDragging ? 5 : 0)
        .offset(draggingItem?.id == item.id ? dragOffset : .zero)
        .opacity(draggingItem?.id == item.id ? 0.7 : 1.0)
        .scaleEffect(draggingItem?.id == item.id ? 1.05 : 1.0)
        .animation(.easeInOut, value: dragOffset)
        .onChange(of: draggingItem) { newValue in
            self.isDragging = newValue?.id == item.id
        }
        .alert(isPresented: Binding<Bool>(
             get: { self.showingAlert },
             set: { _ in }
         )) {
             Alert(
                 title: Text("削除確認"),
                 message: Text("このTodoを削除してもよろしいですか？"),
                 primaryButton: .destructive(Text("削除")) {
                     todoViewModel.removeItem(item)
                 },
                 secondaryButton: .cancel()
             )
         }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日(E)"
        return formatter.string(from: date)
    }
}

// MARK: - TodoListView
struct TodoListView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @State private var newTodoTitle: String = ""
    @State private var postFlag = false
    
    // ドラッグ中のアイテム
    @State private var draggingItem: TodoItem?
    // ドラッグ中の位置
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            userSettingsViewModel.backgroundColor // 背景色を適用
                .ignoresSafeArea()
                .onAppear{
                    print("userSettingsViewModel.settings.backgroundColor:\(userSettingsViewModel.settings.backgroundColor)")
                }
            VStack {
                HStack {
                    Spacer()
                    Text("TODO一覧")
                        .font(.system(size: 20))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color.gray)
                .foregroundColor(Color.white)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(todoViewModel.items) { item in
                            TodoRowView(
                                item: item,
                                draggingItem: $draggingItem,
                                dragOffset: $dragOffset,
                                todoViewModel: todoViewModel
                            )
                        }
                    }
                    .padding()
                }
                
                Spacer()
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
                                      .height(280),
                                      .fraction(isSmallDevice() ? 0.65 : 0.55)
                ])
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    guard let draggingItem = draggingItem else { return }
                    self.dragOffset = value.translation
                    
                    // ドラッグ位置に基づいてアイテムを並び替え
                    if let currentIndex = todoViewModel.items.firstIndex(where: { $0.id == draggingItem.id }) {
                        let newY = value.location.y
                        let itemHeight: CGFloat = 80 // アイテムの高さに合わせて調整
                        let newIndex = Int((newY - 100) / (itemHeight + 10)) // スクロールビューのオフセットに合わせて調整
                        
                        if newIndex >= 0 && newIndex < todoViewModel.items.count {
                            if newIndex != currentIndex {
                                withAnimation {
                                    todoViewModel.reorderItems(draggingItem: draggingItem, to: newIndex)
                                }
                            }
                        }
                    }
                }
                .onEnded { _ in
                    self.draggingItem = nil
                    self.dragOffset = .zero
                }
        )
    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
}


#Preview {
    TodoListView(todoViewModel: TodoViewModel(userID: AuthManager().currentUserId!), userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!))
}
