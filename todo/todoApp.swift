//
//  todoApp.swift
//  todo
//
//  Created by Apple on 2025/01/24.
//

import SwiftUI
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      let authManager = AuthManager()
      authManager.anonymousSignIn(){
          let userDefaults = UserDefaults.standard
          if !userDefaults.bool(forKey: "hasLaunchedSignUp") {
          self.createSampleSettings()
          self.createSampleTodos()
          }
          userDefaults.set(true, forKey: "hasLaunchedSignUp")
          userDefaults.synchronize()
      }
    return true
  }
    
    func createSampleTodos() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("ユーザーがログインしていません createSampleTodos")
            return
        }
        
        let ref = Database.database().reference().child("todos").child(userId)
        let currentTimestamp = Date().timeIntervalSince1970
        let timestamp2 = currentTimestamp + 360000.0  // 例として10秒後のタイムスタンプ
        
        let todo1: [String: Any] = [
            "dueDate": currentTimestamp,
            "isCompleted": false,
            "order": 1,
            "title": "お買い物"
        ]
        let todo2: [String: Any] = [
            "dueDate": timestamp2,
            "isCompleted": false,
            "order": 2,
            "title": "旅行の計画を立てる"
        ]
        
        // 固定のキーではなく childByAutoId() を利用して自動生成
        ref.childByAutoId().setValue(todo1) { error, _ in
            if let error = error {
                print("サンプルTODO1の保存に失敗しました: \(error.localizedDescription)")
            } else {
                print("サンプルTODO1を正常に保存しました。")
            }
        }
        ref.childByAutoId().setValue(todo2) { error, _ in
            if let error = error {
                print("サンプルTODO2の保存に失敗しました: \(error.localizedDescription)")
            } else {
                print("サンプルTODO2を正常に保存しました。")
            }
        }
    }

    
    func createSampleSettings() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("ユーザーがログインしていません createSampleSettings")
            return
        }
        
        let ref = Database.database().reference()
        let sampleSettings: [String: Any] = [
            "background": [
                "backgroundColor": "#FEFEFE",
                "backgroundImageName": "灰1"
            ],
            "header": [
                "headerText": "ToDo一覧",
                "headerImageName": "ヘッダ白11",
                "headerOpacityFlag": false,
                "headerTextColor": "#000000"
            ],
            "postList": [
                "postListImageName": "投稿一覧白1",
                "postListOpacityFlag": false,
                "postListTextColor": "#000000"
            ],
            "plusButton": [
                "plusButtonImageName": "プラスボタン黒1"
            ]
        ]
        
        ref.child("users").child(userId).child("settings").setValue(sampleSettings) { error, _ in
            if let error = error {
                print("Sample settings の保存に失敗しました: \(error.localizedDescription)")
            } else {
                print("Sample settings を正常に保存しました。")
            }
        }
    }
}

@main
struct todoApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var isActive = false
    @StateObject var appState = AppState()

    var body: some Scene {
      WindowGroup {
        NavigationView {
            if !isActive {
               SplashScreenView()
            } else {
               TopView()
            }
        }
        //.navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    if appState.isBannerVisible {
                        AuthManager().updatePreFlag(userId: AuthManager().currentUserId!, userPreFlag: 0){ success in
                        }
                    }
                    self.isActive = true
                }
            }
        }
      }
    }
}
