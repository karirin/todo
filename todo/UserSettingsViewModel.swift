//
//  UserSettingsViewModel.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI
import Firebase


// MARK: - UserSettings Model
struct UserSettings: Codable {
    var backgroundColor: String // Hex string, e.g., "#FFFFFF"
    
    init(backgroundColor: String = "#FFFFFF") { // Default to white
        self.backgroundColor = backgroundColor
    }
}

// MARK: - UserSettingsViewModel
class UserSettingsViewModel: ObservableObject {
    @Published var settings: UserSettings
    @Published var backgroundColor: Color = .white // 初期値は .white だが、fetchSettings で更新
    
    private var ref: DatabaseReference
    private var handle: DatabaseHandle?
    private var userID: String
    
    init(userID: String) {
        self.userID = userID
        ref = Database.database().reference(withPath: "users/\(userID)/settings")
        self.settings = UserSettings()
        fetchSettings()
    }
    
    /// ユーザーIDを更新し、設定を再取得
    func updateUserID(userID: String) {
        if self.userID != userID {
            // 既存のオブザーバーを削除
            if let handle = handle {
                ref.removeObserver(withHandle: handle)
            }
            self.userID = userID
            ref = Database.database().reference(withPath: "users/\(userID)/settings")
            fetchSettings()
        }
    }
    
    deinit {
        if let handle = handle {
            ref.removeObserver(withHandle: handle)
        }
    }
    
    /// Firebaseからユーザー設定を取得
    func fetchSettings() {
        handle = ref.observe(.value, with: { [weak self] snapshot in
            guard let self = self else { return }
            print("Fetching settings for userID: \(self.userID)")
            if let dict = snapshot.value as? [String: Any],
               let bgColor = dict["backgroundColor"] as? String {
                print("Fetched backgroundColor from Firebase: \(bgColor)")
                DispatchQueue.main.async {
                    self.settings.backgroundColor = bgColor
                    self.backgroundColor = Color(hex: bgColor) // 修正箇所
                    print("Updated settings.backgroundColor to: \(bgColor)")
                }
            } else {
                // 設定が存在しない場合はデフォルト値を設定
                print("No backgroundColor found in Firebase for userID: \(self.userID). Setting to default #FFFFFF.")
                DispatchQueue.main.async {
                    self.settings.backgroundColor = "#FFFFFF"
                    self.backgroundColor = .white // デフォルト色を設定
                    print("Updated settings.backgroundColor to default: #FFFFFF")
                }
            }
        })
    }

    
    /// Firebaseに背景色を更新
    func updateBackgroundColor(_ color: Color) {
        guard let hexString = color.toHex() else {
            print("Failed to convert Color to Hex.")
            return
        }
        print("Updating backgroundColor to \(hexString)")
        settings.backgroundColor = hexString
        backgroundColor = color // Colorプロパティを更新
        ref.child("backgroundColor").setValue(hexString) { error, _ in
            if let error = error {
                print("Failed to update backgroundColor: \(error.localizedDescription)")
            } else {
                print("Successfully updated backgroundColor to \(hexString)")
            }
        }
    }
}
