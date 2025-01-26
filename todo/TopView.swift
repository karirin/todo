//
//  TopView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

// MARK: - MainView
struct TopView: View {
    @StateObject var todoViewModel: TodoViewModel
    @StateObject var userSettingsViewModel: UserSettingsViewModel
    
    init() {
        _todoViewModel = StateObject(wrappedValue: TodoViewModel(userID: AuthManager().currentUserId!))
        _userSettingsViewModel = StateObject(wrappedValue: UserSettingsViewModel(userID: AuthManager().currentUserId!))
    }

    var body: some View {
        ZStack {
            
            TabView {
                TodoListView(todoViewModel: todoViewModel, userSettingsViewModel: userSettingsViewModel)
                    .tabItem {
                        Label("Todo", systemImage: "checkmark.circle")
                    }
                
                CalendarView(todoViewModel: todoViewModel)
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                
                ColorPickerView(userSettingsViewModel: userSettingsViewModel)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

#Preview {
    TopView()
}
