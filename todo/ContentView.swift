//
//  ContentView.swift
//  todo
//
//  Created by Apple on 2025/01/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase

// MARK: - ContentView
struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    @StateObject private var todoViewModel: TodoViewModel
    @StateObject private var userSettingsViewModel: UserSettingsViewModel
    
    init() {
        // 初期化時に空の userID を設定
        _todoViewModel = StateObject(wrappedValue: TodoViewModel(userID: ""))
        _userSettingsViewModel = StateObject(wrappedValue: UserSettingsViewModel(userID: ""))
    }
    
    var body: some View {
        ZStack {
            
            // 選択された背景色を適用
            userSettingsViewModel.backgroundColor // 背景色を適用
                .ignoresSafeArea()
                .onAppear{
                    print("userSettingsViewModel.settings.backgroundColor:\(userSettingsViewModel.settings.backgroundColor)")
                }
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
        .onAppear {
            if authManager.user == nil {
                authManager.anonymousSignIn {
                    // サインイン後にuserIDを更新
                    if let userID = authManager.currentUserId {
                        print("Signed in with userID: \(userID)")
                        todoViewModel.updateUserID(userID: userID)
                        userSettingsViewModel.updateUserID(userID: userID)
                    } else {
                        print("Failed to obtain userID after sign-in.")
                    }
                }
            } else {
                if let userID = authManager.currentUserId {
                    print("Already signed in with userID: \(userID)")
                    todoViewModel.updateUserID(userID: userID)
                    userSettingsViewModel.updateUserID(userID: userID)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        userSettingsViewModel.fetchSettings()
                    }
                } else {
                    print("User is signed in but userID is nil.")
                }
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
