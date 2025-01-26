//
//  CalenderView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = Date()
    
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
            }.foregroundColor(.black)
            
            // Weekday Labels
            let japaneseWeekdays = ["日", "月", "火", "水", "木", "金", "土"]
            HStack {
                ForEach(japaneseWeekdays, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
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
                HStack {
                    Image(systemName: "calendar.circle")
                        .font(.system(size: 20))
                    Text("\(formattedDate(selectedDate))")
                        .font(.headline)
                    Spacer()
                }
                .padding(.leading)
                
                let filteredTodos = todoViewModel.items.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
                
                if filteredTodos.isEmpty {
                    Text("この日にTodoはありません")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(filteredTodos) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    todoViewModel.toggleCompletion(of: item)
                                }
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.system(size: 18))
                                    .strikethrough(item.isCompleted, color: .black)
                                    .foregroundColor(item.isCompleted ? .gray : .black)
                                Text("期限: \(formattedDate(item.dueDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            todoViewModel.toggleCompletion(of: item)
                        }
                        Divider()
                    }
                }
            }
            
            Spacer()
        }
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
    CalendarView(todoViewModel: TodoViewModel(userID: AuthManager().currentUserId!))
}
