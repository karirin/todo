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
                    Label("カレンダー", systemImage: "calendar")
                }
            PresetEditorView(userSettingsViewModel: userSettingsViewModel)
                .tabItem {
                    Label("カスタマイズ", systemImage: "rectangle.grid.2x2")
                }
            SettingView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
        }
    }
}

#Preview {
    TopView()
}
