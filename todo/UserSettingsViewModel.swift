//
//  UserSettingsViewModel.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI
import Firebase

struct UserSettings: Codable {
    var backgroundColor: String // Hex string, e.g., "#FFFFFF"
    var backgroundImageName: String? // Optional: Image name from assets
    
    init(backgroundColor: String = "#FFFFFF", backgroundImageName: String? = nil) {
        self.backgroundColor = backgroundColor
        self.backgroundImageName = backgroundImageName
    }
}

class UserSettingsViewModel: ObservableObject {
    @Published var settings: UserSettings
    @Published var backgroundColor: Color = .white // 初期値は .white だが、fetchSettings で更新
    @Published var backgroundImageName: String? = nil // 画像表示用
    
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
            if let dict = snapshot.value as? [String: Any] {
                if let bgColor = dict["backgroundColor"] as? String {
                    DispatchQueue.main.async {
                        self.settings.backgroundColor = bgColor
                        self.backgroundColor = Color(hex: bgColor)
                    }
                }
                if let bgImageName = dict["backgroundImageName"] as? String {
                    DispatchQueue.main.async {
                        self.settings.backgroundImageName = bgImageName
                        self.backgroundImageName = bgImageName
                    }
                } else {
                    DispatchQueue.main.async {
                        self.settings.backgroundImageName = nil
                        self.backgroundImageName = nil
                    }
                }
            } else {
                // 設定が存在しない場合はデフォルト値を設定
                DispatchQueue.main.async {
                    self.settings.backgroundColor = "#FFFFFF"
                    self.backgroundColor = .white
                    self.backgroundImageName = nil
                }
            }
        })
    }
    
    /// 背景色を更新
    func updateBackgroundColor(_ color: Color) {
        guard let hexString = color.toHex() else {
            return
        }
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
    
    /// 背景画像を更新
    func updateBackgroundImage(named imageName: String) {
        settings.backgroundImageName = imageName
        backgroundImageName = imageName
        ref.child("backgroundImageName").setValue(imageName) { error, _ in
            if let error = error {
                print("Failed to update backgroundImageName: \(error.localizedDescription)")
            } else {
                print("Successfully updated backgroundImageName to \(imageName)")
            }
        }
    }
    
    /// 背景画像をクリア
    func clearBackgroundImage() {
        settings.backgroundImageName = nil
        backgroundImageName = nil
        ref.child("backgroundImageName").removeValue { error, _ in
            if let error = error {
                print("Failed to clear backgroundImageName: \(error.localizedDescription)")
            } else {
                print("Successfully cleared backgroundImageName")
            }
        }
    }
}
