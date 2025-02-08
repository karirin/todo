//
//  TodoListView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

struct TodoRowView: View {
    let item: TodoItem
    @Binding var draggingItem: TodoItem?
    @Binding var dragOffset: CGSize
    @Binding var isCustomizationMode: Bool
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var todoViewModel: TodoViewModel
    @State private var showingAlert = false
    @State private var isDragging: Bool = false
    @State private var originalOrder: Int = 0
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    
    var body: some View {
        HStack {
            // チェックボタン
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20))
                .foregroundColor(item.isCompleted ? .green : .black)
                .onTapGesture {
                    generateHapticFeedback()
                    if isCustomizationMode {
                        activeSheet = .postListEditor
                    } else {
                        todoViewModel.toggleCompletion(of: item)
                    }
                }
                .background(Color("backgroundColor").opacity(userSettingsViewModel.postListOpacityFlag ? 0.6 : 0))
                .cornerRadius(10)
                .padding(.trailing, 0)
            
            // タイトルと期限日
            HStack{
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .strikethrough(item.isCompleted, color: .black)
                        .foregroundColor(item.isCompleted ? .gray : userSettingsViewModel.postListTextColor)
                        .background(Color("backgroundColor").opacity(userSettingsViewModel.postListOpacityFlag ? 0.6 : 0))
                        .clipShape(RoundedCorner(radius: 5, corners: [.topLeft, .topRight]))
                    HStack {
                        Image(systemName: "calendar.circle")
                            .font(.system(size: 16))
                            .padding(.trailing, -5)
                        Text("\(formattedDate(item.dueDate))")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(item.isCompleted ? .gray : userSettingsViewModel.postListTextColor)
                    .background(Color("backgroundColor").opacity(userSettingsViewModel.postListOpacityFlag ? 0.6 : 0))
                    .clipShape(RoundedCorner(radius: 5, corners: [.topRight,.bottomLeft, .bottomRight]))
                }
                .padding(5)
                .cornerRadius(5)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                if isCustomizationMode {
                    activeSheet = .postListEditor
                } else {
                    todoViewModel.toggleCompletion(of: item)
                }
            }
            Button(action: {
                print("trash1")
                generateHapticFeedback()
                if isCustomizationMode {
                    activeSheet = .postListEditor
                } else {
                    print("trash2")
                    showingAlert = true
                }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
            }
            .background(Color("backgroundColor").opacity(userSettingsViewModel.postListOpacityFlag ? 0.6 : 0))
            .cornerRadius(5)
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
//            isDragging ? Color.blue.opacity(0.2) : Color.white
            Group {
                if let headerImageName = userSettingsViewModel.postListImageName,
                   let uiImage = UIImage(named: headerImageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    userSettingsViewModel.postListColor
                        .edgesIgnoringSafeArea(.all)
                }
            }
        )
        .cornerRadius(8)
        .onTapGesture {
            if isCustomizationMode {
                activeSheet = .postListEditor
            }
        }
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
            set: { self.showingAlert = $0 }
        )) {
            Alert(
                title: Text("削除確認"),
                message: Text("「\(item.title)」を削除してもよろしいですか？"),
                primaryButton: .destructive(Text("削除")) {
                    todoViewModel.removeItem(item)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日(E)"
        return formatter.string(from: date)
    }
}

enum ActiveSheet: Identifiable {
    case addPost
    case backgroundEditor
    case headerEditor
    case plusButtonEditor
    case postListEditor
    
    var id: Int {
        hashValue
    }
}

struct TodoListView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @State private var newTodoTitle: String = ""
    @State private var postFlag = false
    @State private var isCustomizationMode: Bool = false
    @State private var showBackgroundEditor: Bool = false
    @State private var draggingItem: TodoItem?
    @State private var dragOffset: CGSize = .zero
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        ZStack {
            if let imageName = userSettingsViewModel.backgroundImageName,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .shadow(color: isCustomizationMode ? Color.black : Color.clear, radius: 20)
            } else {
                userSettingsViewModel.backgroundColor
                    .ignoresSafeArea()
                    .shadow(color: isCustomizationMode ? Color.black : Color.clear, radius: 10)
            }
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            generateHapticFeedback()
                            isCustomizationMode.toggle()
                        }) {
                            Image(isCustomizationMode ? "編集中" : "編集前" )
                                .resizable()
                                .scaledToFit()
                                .frame(height:50)
                                .zIndex(isCustomizationMode ? 1 : 0)
                        }
                        .padding(.leading)
                        .opacity(0)
                        Spacer()
                        Text(userSettingsViewModel.headerText)
                            .foregroundColor(userSettingsViewModel.headerTextColor)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.horizontal,5)
                            .background(Color("backgroundColor").opacity(userSettingsViewModel.headerOpacityFlag ? 0.6 : 0))
                            .cornerRadius(10)
                        Spacer()
                        Button(action: {
                            generateHapticFeedback()
                            isCustomizationMode.toggle()
                        }) {
                            Image(isCustomizationMode ? "編集中" : "編集前" )
                                .resizable()
                                .scaledToFit()
                                .frame(height:50)
                                .zIndex(isCustomizationMode ? 1 : 0)
                        }
                        .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(
                        Group {
                            if let headerImageName = userSettingsViewModel.headerImageName,
                               let uiImage = UIImage(named: headerImageName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .edgesIgnoringSafeArea(.all)
                                
                                .shadow(color: isCustomizationMode ? Color.black.opacity(0.9) : Color.clear, radius: 10)
                            } else {
                                userSettingsViewModel.headerColor
                                    .edgesIgnoringSafeArea(.all)
                                
                                .shadow(color: isCustomizationMode ? Color.black.opacity(0.9) : Color.clear, radius: 10)
                            }
                        }
                    )
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        if isCustomizationMode {
                            print("headerEditor")
                            activeSheet = .headerEditor
                        }
                    }
                }
                VStack(spacing: 10) {
                    ForEach(todoViewModel.items) { item in
                        ZStack{
                            TodoRowView(
                                item: item,
                                draggingItem: $draggingItem,
                                dragOffset: $dragOffset, isCustomizationMode: $isCustomizationMode, activeSheet: $activeSheet,
                                todoViewModel: todoViewModel, userSettingsViewModel: userSettingsViewModel
                            ).shadow(color: isCustomizationMode ? Color.black : Color.clear, radius: 10)
                        }
                        .onTapGesture {
                            if isCustomizationMode {
                                activeSheet = .postListEditor
                            }
                        }
                    }
                }
                .padding()
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isCustomizationMode {
                            activeSheet = .backgroundEditor
                        }
                    }
            }
        }
        .overlay(
            ZStack {
                Spacer()
                HStack {
                    VStack{
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                generateHapticFeedback()
                                if isCustomizationMode {
                                    activeSheet = .plusButtonEditor
                                } else {
                                    activeSheet = .addPost
                                    guard !newTodoTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                                }
                            }) {
                                if let plusButtonImageName = userSettingsViewModel.plusButtonImageName,
                                   let uiImage = UIImage(named: plusButtonImageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70)
                                } else {
                                    Image(systemName: "plus")
                                        .font(.system(size: 30))
                                        .padding(20)
                                        .background(userSettingsViewModel.plusButtonColor)
                                        .foregroundColor(Color.white)
                                        .clipShape(Circle())
                                }
                            }
                            .shadow(radius: 10)
                            .padding()
                            .shadow(color: isCustomizationMode ? Color.black : Color.clear, radius: 10)
                        }
                    }
                }
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(item: $activeSheet) { item in
            switch item {
            case .addPost:
                AddPostView(text: $newTodoTitle, todoViewModel: todoViewModel)
                    .presentationDetents([.large,
                                          .height(280),
                                          .fraction(isSmallDevice() ? 0.65 : 0.55)
                    ])
            case .backgroundEditor:
                BackgroundImageView(userSettingsViewModel: userSettingsViewModel)
                    .presentationDetents([.large])
            case .headerEditor:
                HeaderEditorView(userSettingsViewModel: userSettingsViewModel)
                    .presentationDetents([.large])
            case .plusButtonEditor:
                PlusButtonEditorView(userSettingsViewModel: userSettingsViewModel)
                    .presentationDetents([.large])
            case .postListEditor:
                PostListEditorView(todoViewModel: todoViewModel, userSettingsViewModel: userSettingsViewModel)
                    .presentationDetents([.large])
            }
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
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    TodoListView(todoViewModel: TodoViewModel(userID: AuthManager().currentUserId!), userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!))
}
