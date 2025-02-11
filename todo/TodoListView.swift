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
                    generateHapticFeedback()
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
        .padding(10)
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

struct ViewPositionKey: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey2: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey3: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey4: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey5: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey6: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey7: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey8: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey9: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey10: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey11: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey12: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey13: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey14: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey15: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey16: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct ViewPositionKey17: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
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
    @State private var tutorialNum: Int = 0
    @State private var position: Int = 1
    @State private var buttonRect: CGRect = .zero
    @State private var bubbleHeight: CGFloat = 0.0
    @State private var buttonRect2: CGRect = .zero
    @State private var bubbleHeight2: CGFloat = 0.0
    @State private var buttonRect3: CGRect = .zero
    @State private var bubbleHeight3: CGFloat = 0.0
    @State private var buttonRect4: CGRect = .zero
    @State private var bubbleHeight4: CGFloat = 0.0
    @State private var buttonRect5: CGRect = .zero
    @State private var bubbleHeight5: CGFloat = 0.0
    @State private var buttonRect6: CGRect = .zero
    @State private var bubbleHeight6: CGFloat = 0.0
    @State private var buttonRect7: CGRect = .zero
    @State private var bubbleHeight7: CGFloat = 0.0
    @State private var buttonRect8: CGRect = .zero
    @State private var bubbleHeight8: CGFloat = 0.0
    
    var body: some View {
        VStack{
            if userSettingsViewModel.isLoading {
                LoadingView()
            } else {
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
                                    tutorialNum = 4
                                }) {
                                    Image(systemName: "questionmark.circle.fill" )
                                        .font(.system(size: 35))
                                        .foregroundColor(.black)
                                }
                                .padding(.leading)
                                .opacity(isCustomizationMode ? 1 : 0)
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
                                    if tutorialNum == 3 {
                                        tutorialNum = 4
                                    }
                                    isCustomizationMode.toggle()
                                }) {
                                    Image(isCustomizationMode ? "編集中" : "編集前" )
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height:40)
                                        .zIndex(isCustomizationMode ? 1 : 0)
                                }
                                .background(GeometryReader { geometry in
                                    Color.clear.preference(key: ViewPositionKey.self, value: [geometry.frame(in: .global)])
                                })
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
                            .background(GeometryReader { geometry in
                                Color.clear.preference(key: ViewPositionKey7.self, value: [geometry.frame(in: .global)])
                            })
                        }
                        
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(todoViewModel.items) { item in
                                    ZStack{
                                        TodoRowView(
                                            item: item,
                                            draggingItem: $draggingItem,
                                            dragOffset: $dragOffset, isCustomizationMode: $isCustomizationMode, activeSheet: $activeSheet,
                                            todoViewModel: todoViewModel, userSettingsViewModel: userSettingsViewModel
                                        ).shadow(color: isCustomizationMode ? Color.black : Color.clear, radius: 10)
                                            .background(GeometryReader { geometry in
                                                Color.clear.preference(key: ViewPositionKey8.self, value: [geometry.frame(in: .global)])
                                            })
                                    }
                                    .onTapGesture {
                                        if isCustomizationMode {
                                            activeSheet = .postListEditor
                                        }
                                    }
                                }
                            }
                            .padding()
                            .padding(.bottom, 60)
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
                                        }                            .background(GeometryReader { geometry in
                                            Color.clear.preference(key: ViewPositionKey2.self, value: [geometry.frame(in: .global)])
                                        })
                                        .shadow(radius: 10)
                                        .padding()
                                        .shadow(color: isCustomizationMode ? Color.black : Color.clear, radius: 10)
                                    }
                                }
                            }
                            HStack {
                                VStack{
                                    Spacer()
                                    HStack {
                                        Button(action: {
                                            generateHapticFeedback()
                                            if isCustomizationMode {
                                                activeSheet = .backgroundEditor
                                            }
                                        }) {
                                            HStack(spacing: 5) {
                                                Image(systemName: "square.and.pencil.circle")
                                                    .font(.system(size: 24))
                                                Text("背景編集")
                                            }
                                                .padding(10)
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                                .background(Color.white)
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.black, lineWidth: 1)
                                                )
                                                .shadow(radius: 10)
                                                .background(GeometryReader { geometry in
                                                    Color.clear.preference(key: ViewPositionKey9.self, value: [geometry.frame(in: .global)])
                                                })
                                                .padding(.bottom, 10)
                                                .opacity(isCustomizationMode ? 1 : 0)
                                        }
                                        .padding()
                                    }
                                }
                            }
                        }
                    )
                    if tutorialNum == 1 {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                generateHapticFeedback()
                                tutorialNum = 2
                            }
                        VStack {
                            Spacer()
                                //.frame(height: buttonRect.minY - bubbleHeight + 150)
                            VStack(alignment: .trailing, spacing: 15) {
                                VStack{
                                Image("ロゴ")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .frame(height:80)
                                    .padding(.bottom)
                                Text("インストールありがとうございます！\n\nこのアプリは自分好みにToDoアプリをカスタマイズできるアプリです\n早速カスタマイズ方法について紹介します")
                            }
                            .font(.callout)
                            .padding(5)
                            .font(.system(size: 24.0))
                            .padding(.all, 16.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 4)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 2
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 8)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                                }
                            }
                            .background(GeometryReader { geometry in
                                Path { _ in
                                    DispatchQueue.main.async {
                                        self.bubbleHeight = geometry.size.height
                                    }
                                }
                            })
                            Spacer()
                        }
                        .onTapGesture {
                            generateHapticFeedback()
                            tutorialNum = 2
                        }
                        .ignoresSafeArea()
                        VStack{
                            HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left.2")
                                        Text("スキップ")
                                    }
                                    .padding(5)
                                    .font(.system(size: 20.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Spacer()
                            }
                            Spacer()
                    }
                    }
                    if tutorialNum == 2 {
                        GeometryReader { geometry in
                            Color.black.opacity(0.5)
                                .overlay(
                                    Circle()
                                        .padding(-10)
                                        .frame(width: buttonRect.width, height: buttonRect.height)
                                        .position(x: buttonRect.midX, y: buttonRect.midY)
                                        .blendMode(.destinationOut)
                                )
                                .ignoresSafeArea()
                                .compositingGroup()
                                .background(.clear)
                                .onTapGesture {
                                    generateHapticFeedback()
                                    tutorialNum = 3
                                }
                        }
                        VStack {
                            Spacer()
                                .frame(height: buttonRect.minY - bubbleHeight + 200)
                            VStack(alignment: .trailing, spacing: 10) {
                                HStack {
                                    Spacer()
                                Text("編集モードにするために\n右上のボタンをクリックします")
                                    .font(.callout)
                                    .padding(5)
                                    .font(.system(size: 24.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 3
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                                }
                            }
                            .background(GeometryReader { geometry in
                                Path { _ in
                                    DispatchQueue.main.async {
                                        self.bubbleHeight = geometry.size.height
                                    }
                                }
                            })
                            Spacer()
                        }
                        .ignoresSafeArea()
                        VStack{
                            Spacer()
                            HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left.2")
                                        Text("スキップ")
                                    }
                                    .padding(5)
                                    .font(.system(size: 20.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    if tutorialNum == 4 {
                        GeometryReader { geometry in
                            Color.black.opacity(0.5)
                                .overlay(
                                    Circle()
                                        .padding(-10)
                                        .frame(width: buttonRect2.width, height: buttonRect2.height)
                                        .position(x: buttonRect2.midX, y: buttonRect2.midY)
                                        .blendMode(.destinationOut)
                                )
                                .ignoresSafeArea()
                                .compositingGroup()
                                .background(.clear)
                                .onTapGesture {
                                    generateHapticFeedback()
                                    tutorialNum = 5
                                }
                        }
                        VStack {
                            Spacer()
                                .frame(height: buttonRect2.minY - bubbleHeight2 - 130)
                            VStack(alignment: .trailing, spacing: 10) {
                                HStack {
                                    Spacer()
                                Text("右下のボタンをクリックします")
                                    .font(.callout)
                                    .padding(5)
                                    .font(.system(size: 24.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 5
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                                }
                            }
                            .background(GeometryReader { geometry in
                                Path { _ in
                                    DispatchQueue.main.async {
                                        self.bubbleHeight = geometry.size.height
                                    }
                                }
                            })
                            Spacer()
                        }
                        .ignoresSafeArea()
                        VStack{
                            Spacer()
                            HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left.2")
                                        Text("スキップ")
                                    }
                                    .padding(5)
                                    .font(.system(size: 20.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    if tutorialNum == 10 {
                        GeometryReader { geometry in
                            Color.black.opacity(0.5)
                                .overlay(
                                    Circle()
                                        .padding(-10)
                                        .frame(width: buttonRect2.width, height: buttonRect2.height)
                                        .position(x: buttonRect2.midX, y: buttonRect2.midY)
                                        .blendMode(.destinationOut)
                                )
                                .ignoresSafeArea()
                                .compositingGroup()
                                .background(.clear)
                                .onTapGesture {
                                    generateHapticFeedback()
                                    tutorialNum = 11
                                }
                        }
                        VStack {
                            Spacer()
                                .frame(height: buttonRect2.minY - bubbleHeight2 - 150)
                            VStack(alignment: .trailing, spacing: 10) {
                                HStack {
                                    Spacer()
                                Text("プラスボタンが変わっていることを確認します")
                                    .font(.callout)
                                    .padding(5)
                                    .font(.system(size: 24.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 11
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                                }
                            }
                            .background(GeometryReader { geometry in
                                Path { _ in
                                    DispatchQueue.main.async {
                                        self.bubbleHeight = geometry.size.height
                                    }
                                }
                            })
                            Spacer()
                        }
                        .ignoresSafeArea()
                        VStack{
                            Spacer()
                            HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left.2")
                                        Text("スキップ")
                                    }
                                    .padding(5)
                                    .font(.system(size: 20.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    if tutorialNum == 11 {
                        GeometryReader { geometry in
                            Color.black.opacity(0.5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(width: buttonRect3.width, height: buttonRect3.height)
                                        .position(x: buttonRect3.midX, y: buttonRect3.midY)
                                        .blendMode(.destinationOut)
                                )
                                .ignoresSafeArea()
                                .compositingGroup()
                                .background(.clear)
                                .onTapGesture {
                                    generateHapticFeedback()
                                    tutorialNum = 12
                                }
                        }
                        VStack {
                            Spacer()
                                .frame(height: buttonRect3.minY - bubbleHeight3 + 180)
                            VStack(alignment: .trailing, spacing: 10) {
                                HStack {
                                Text("その他にも「ヘッダー」や")
                                    .font(.callout)
                                    .padding(5)
                                    .font(.system(size: 24.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 12
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                                }
                            }
                            .background(GeometryReader { geometry in
                                Path { _ in
                                    DispatchQueue.main.async {
                                        self.bubbleHeight3 = geometry.size.height
                                    }
                                }
                            })
                            Spacer()
                        }
                        .ignoresSafeArea()
                        VStack{
                            Spacer()
                            HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left.2")
                                        Text("スキップ")
                                    }
                                    .padding(5)
                                    .font(.system(size: 20.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    if tutorialNum == 12 {
                        GeometryReader { geometry in
                            Color.black.opacity(0.5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(width: buttonRect4.width, height: buttonRect4.height)
                                        .position(x: buttonRect4.midX, y: buttonRect4.midY)
                                        .blendMode(.destinationOut)
                                )
                                .ignoresSafeArea()
                                .compositingGroup()
                                .background(.clear)
                                .onTapGesture {
                                    generateHapticFeedback()
                                    tutorialNum = 13
                                }
                        }
                        VStack {
                            Spacer()
                                .frame(height: buttonRect4.minY - bubbleHeight4 + 210)
                            VStack(alignment: .trailing, spacing: 10) {
                                HStack {
                                Text("「TODO」リスト")
                                    .font(.callout)
                                    .padding(5)
                                    .font(.system(size: 24.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 13
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                                }
                            }
                            .background(GeometryReader { geometry in
                                Path { _ in
                                    DispatchQueue.main.async {
                                        self.bubbleHeight4 = geometry.size.height
                                    }
                                }
                            })
                            Spacer()
                        }
                        .ignoresSafeArea()
                        VStack{
                            Spacer()
                            HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left.2")
                                        Text("スキップ")
                                    }
                                    .padding(5)
                                    .font(.system(size: 20.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    if tutorialNum == 13 {
                        GeometryReader { geometry in
                            Color.black.opacity(0.5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(width: buttonRect5.width, height: buttonRect5.height)
                                        .position(x: buttonRect5.midX, y: buttonRect5.midY)
                                        .blendMode(.destinationOut)
                                )
                                .ignoresSafeArea()
                                .compositingGroup()
                                .background(.clear)
                                .onTapGesture {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }
                        }
                        VStack {
                            Spacer()
                                .frame(height: buttonRect5.minY - bubbleHeight5)
                            VStack(alignment: .trailing, spacing: 10) {
                                HStack {
                                Text("「背景」までカスタマイズできます\n自分好みのTODOアプリにしてみましょう！")
                                    .font(.callout)
                                    .padding(5)
                                    .font(.system(size: 24.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                                }
                            }
                            .background(GeometryReader { geometry in
                                Path { _ in
                                    DispatchQueue.main.async {
                                        self.bubbleHeight5 = geometry.size.height
                                    }
                                }
                            })
                            Spacer()
                        }
                        .ignoresSafeArea()
                        VStack{
                            HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 0
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left.2")
                                        Text("スキップ")
                                    }
                                    .padding(5)
                                    .font(.system(size: 20.0))
                                    .padding(.all, 8.0)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color.black)
                                    .shadow(radius: 10)
                                }
                                Spacer()
                            }
                            .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
        .onPreferenceChange(ViewPositionKey.self) { positions in
            self.buttonRect = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey2.self) { positions in
            self.buttonRect2 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey7.self) { positions in
            self.buttonRect3 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey8.self) { positions in
            self.buttonRect4 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey9.self) { positions in
            self.buttonRect5 = positions.first ?? .zero
        }
        .onAppear {
            let userDefaults = UserDefaults.standard
            if !userDefaults.bool(forKey: "hasLaunchedTutorialOnappear") {
                tutorialNum = 1
            }
            userDefaults.set(true, forKey: "hasLaunchedTutorialOnappear")
            userDefaults.synchronize()
        }
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
                PlusButtonEditorView(userSettingsViewModel: userSettingsViewModel, tutorialNum: $tutorialNum)
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
    TodoListView(todoViewModel: TodoViewModel(), userSettingsViewModel: UserSettingsViewModel())
}
