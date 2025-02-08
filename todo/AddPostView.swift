//
//  AddPostView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

struct AddPostView: View {
    @Binding var text: String
    @ObservedObject var todoViewModel: TodoViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date = Date()
    @State private var isCalendarVisible: Bool = false // カレンダー表示の状態管理
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ScrollView { // スクロールビューを追加して、キーボード表示時のレイアウト崩れを防ぐ
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    Text("ToDoを追加する")
                        .font(.headline)
                    Spacer()
                }
                
                TextField("新しいタスクを入力", text: $text)
                    .border(Color.clear, width: 0)
                    .font(.system(size: 20))
                    .cornerRadius(8)
                    .focused($isTextFieldFocused)
                Divider()
                
                // 日付選択用のボタン群
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        Text("ToDo実施日")
                            .font(.headline)
                        Spacer()
                    }
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            generateHapticFeedback()
                            withAnimation {
                                isCalendarVisible.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "calendar.circle")
                                    .font(.system(size: isSmallDevice() ? 20 : 24))
                                Text(" \(formattedDate(selectedDate))")
                                    .font(.system(size: 20))
                                    .padding(.leading, -8)
                            }
                            .padding(5)
                            .padding(.horizontal,5)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        
                        Button(action: {
                            generateHapticFeedback()
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                        }) {
                            Text("前日")
                        }
                        .padding(8)
                        .foregroundColor(.gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        
                        Button(action: {
                            generateHapticFeedback()
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                        }) {
                            Text("翌日")
                        }
                        .padding(8)
                        .foregroundColor(.gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    // カレンダー（日付ピッカー）の表示
                    if isCalendarVisible {
                        DatePicker("期限日を選択", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .transition(.slide)
                    }
                }
                
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
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .padding(.top, 10)
                .shadow(radius: 3)
            }
            .padding()
            .onAppear {
                DispatchQueue.main.async {
                    self.isTextFieldFocused = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本に設定
        formatter.dateFormat = "yyyy年M月d日(E)" // カスタムフォーマット
        return formatter.string(from: date)
    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
}

#Preview {
    AddPostView(text: .constant("test"), todoViewModel: TodoViewModel(userID: AuthManager().currentUserId!))
}
