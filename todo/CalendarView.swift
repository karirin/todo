//
//  CalenderView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = Date()
    
    var body: some View {
        ZStack {
            if let imageName = userSettingsViewModel.backgroundImageName,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
            VStack {

                // Header: Month Navigation
                HStack {
                    Button(action: {
                        generateHapticFeedback()
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.bold)
                            .padding(5)
                            .background(Color("backgroundColor").opacity(userSettingsViewModel.headerOpacityFlag ? 0.6 : 0))
                            .cornerRadius(10)
                            .padding()
                    }
                    Spacer()
                    Text(monthYearFormatter.string(from: currentDate))
                        .foregroundColor(userSettingsViewModel.headerTextColor)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(.horizontal,5)
                        .background(Color("backgroundColor").opacity(userSettingsViewModel.headerOpacityFlag ? 0.6 : 0))
                        .cornerRadius(10)
                    Spacer()
                    Button(action: {
                        generateHapticFeedback()
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.right")
                            .fontWeight(.bold)
                            .padding(5)
                            .background(Color("backgroundColor").opacity(userSettingsViewModel.headerOpacityFlag ? 0.6 : 0))
                            .cornerRadius(10)
                            .padding()
                    }
                }
                .foregroundColor(.black)
                .background(
                        Group {
                            if let headerImageName = userSettingsViewModel.headerImageName,
                               let uiImage = UIImage(named: headerImageName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .edgesIgnoringSafeArea(.all)
                            }
                        }
                    )
                // Weekday Labels
                VStack {
                    let japaneseWeekdays = ["日", "月", "火", "水", "木", "金", "土"]
                    HStack {
                        ForEach(japaneseWeekdays, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.top)
                    // Date Grid
                    let daysInMonth = generateDaysInMonth(for: currentDate)
                    let columns = Array(repeating: GridItem(.flexible()), count: 7)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(daysInMonth, id: \.self) { date in
                            if let date = date {
                                let hasTodo = todoViewModel.items.contains { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
                                
                                Button(action: {
                                    generateHapticFeedback()
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
                            }
                        }
                    }
                }
                .background(Color("backgroundColor"))
                .padding(.top, -15)
                
                // Selected Date's Todo List
                if let selectedDate = selectedDate {
                    HStack {
                        HStack{
                            Image(systemName: "calendar.circle")
                                .font(.system(size: 20))
                            Text("\(formattedDate(selectedDate))")
                            
                            .font(.system(size: 20))
                        }
                        .padding(.horizontal, 5)
                        .background(Color("backgroundColor").opacity(0.6))
                        .cornerRadius(30)
                        Spacer()
                    }
                    .padding(.leading)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    
                    let filteredTodos = todoViewModel.items.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
                    
                    if filteredTodos.isEmpty {
                        Text("この日にTodoはありません")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .padding(.horizontal, 5)
                            .background(Color("backgroundColor").opacity(0.6))
                            .cornerRadius(30)
                            .padding(.top)
                    } else {
                        ForEach(filteredTodos) { item in
                            HStack {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(userSettingsViewModel.postListTextColor)
                                    .onTapGesture {
                                        todoViewModel.toggleCompletion(of: item)
                                    }
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .strikethrough(item.isCompleted, color: .black)
                                        .foregroundColor(item.isCompleted ? .gray : userSettingsViewModel.postListTextColor)
                                        .background(Color("backgroundColor").opacity(userSettingsViewModel.postListOpacityFlag ? 0.6 : 0))
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .shadow(color:  Color.gray.opacity(0.2), radius: 5)
                            .contentShape(Rectangle())
                            .background(
                    //            isDragging ? Color.blue.opacity(0.2) : Color.white
                                Group {
                                    if let headerImageName = userSettingsViewModel.postListImageName,
                                       let uiImage = UIImage(named: headerImageName) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .edgesIgnoringSafeArea(.all)
                                    }
                                }
                            )
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            .onTapGesture {
                                generateHapticFeedback()
                                todoViewModel.toggleCompletion(of: item)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if value.translation.width < 0 {
                        // 左へスワイプ → 来月へ
                        generateHapticFeedback()
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    } else if value.translation.width > 0 {
                        // 右へスワイプ → 前月へ
                        generateHapticFeedback()
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }
                }
        )
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // Month and Year Formatter
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本に設定
        formatter.dateFormat = "yyyy年M月" // 月を数字で表示
        return formatter
    }
    
    // Full Date Formatter
    private var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本に設定
        return formatter
    }
    
    // Date Formatter for Todo Items
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本に設定
        formatter.dateFormat = "yyyy年M月d日(E)" // カスタムフォーマット
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
    CalendarView(todoViewModel: TodoViewModel(), userSettingsViewModel: UserSettingsViewModel())
}
