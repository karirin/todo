//
//  TopView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

struct TopView: View {
    @StateObject var todoViewModel = TodoViewModel()
    @StateObject var userSettingsViewModel = UserSettingsViewModel()


    var body: some View {
        TabView {
            TodoListView(todoViewModel: todoViewModel, userSettingsViewModel: userSettingsViewModel)
                .tabItem {
                    Label("Todo", systemImage: "checkmark.circle")
                }
            CalendarView(todoViewModel: todoViewModel, userSettingsViewModel: userSettingsViewModel)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            PresetEditorView(userSettingsViewModel: userSettingsViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    TopView()
}
