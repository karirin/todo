//
//  UserSettingsViewModel.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI
import Firebase

// 各設定項目のモデル
struct BackgroundSettings: Codable {
    var backgroundColor: String // Hex string, e.g., "#FFFFFF"
    var backgroundImageName: String? // Optional: Image name from assets
}

struct HeaderSettings: Codable {
    var headerColor: String // Hexコードで保存
    var headerImageName: String?
    var headerText: String
    var headerTextColor: String // 新規追加: Hexコードで保存
}

struct ButtonSettings: Codable {
    var buttonColor: String // Hex string
    var buttonImageName: String? // Optional: Image name from assets
}

struct PostListSettings: Codable {
    var postListColor: String // Hex string
    var postListImageName: String? // Optional: Image name from assets
    var isReorderEnabled: Bool // 並び替え機能の有効化
}

// メインのユーザー設定モデル
struct UserSettings: Codable {
    var background: BackgroundSettings
    var header: HeaderSettings
    var button: ButtonSettings
    var postList: PostListSettings
    
    init(
        background: BackgroundSettings = BackgroundSettings(backgroundColor: "#FFFFFF", backgroundImageName: nil),
        header: HeaderSettings = HeaderSettings(headerColor: "#FFFFFF", headerImageName: nil, headerText: "TODO一覧", headerTextColor: "#000000"),
        button: ButtonSettings = ButtonSettings(buttonColor: "#FFFFFF", buttonImageName: nil),
        postList: PostListSettings = PostListSettings(postListColor: "#FFFFFF", postListImageName: nil, isReorderEnabled: true)
    ) {
        self.background = background
        self.header = header
        self.button = button
        self.postList = postList
    }
}

class UserSettingsViewModel: ObservableObject {
    @Published var settings: UserSettings
    @Published var backgroundColor: Color = .white
    @Published var backgroundImageName: String? = nil
    @Published var headerColor: Color = .white
    @Published var headerImageName: String? = nil
    @Published var headerText: String = "TODO一覧"
    @Published var headerTextColor: Color = .black
    @Published var buttonColor: Color = .white
    @Published var buttonImageName: String? = nil
    @Published var postListColor: Color = .white
    @Published var postListImageName: String? = nil
    @Published var isReorderEnabled: Bool = true
    
    private var ref: DatabaseReference
    private var handle: DatabaseHandle?
    private var userID: String
    
    init(userID: String, mockSettings: UserSettings? = nil) {
        self.userID = userID // userID を初期化
        self.ref = Database.database().reference().child("users").child(userID).child("settings") // Firebase のパスを修正
        if let mock = mockSettings {
            self.settings = mock
            self.backgroundColor = Color(hex: mock.background.backgroundColor)
            self.backgroundImageName = mock.background.backgroundImageName
            self.headerColor = Color(hex: mock.header.headerColor)
            self.headerImageName = mock.header.headerImageName
            self.headerText = mock.header.headerText
            self.headerTextColor = Color(hex: mock.header.headerTextColor) // 新規追加
            self.buttonColor = Color(hex: mock.button.buttonColor)
            self.buttonImageName = mock.button.buttonImageName
            self.postListColor = Color(hex: mock.postList.postListColor)
            self.postListImageName = mock.postList.postListImageName
            self.isReorderEnabled = mock.postList.isReorderEnabled
        } else {
            // 初期設定
            self.settings = UserSettings()
            self.fetchSettings()
        }
    }
    
    deinit {
        if let handle = handle {
            ref.removeObserver(withHandle: handle)
        }
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
    
    /// Firebaseからユーザー設定を取得
    func fetchSettings() {
        handle = ref.observe(.value, with: { [weak self] snapshot in
            guard let self = self else { return }
            if let dict = snapshot.value as? [String: Any] {
                // 背景設定
                if let bgDict = dict["background"] as? [String: Any],
                   let bgColor = bgDict["backgroundColor"] as? String {
                    DispatchQueue.main.async {
                        self.settings.background.backgroundColor = bgColor
                        self.backgroundColor = Color(hex: bgColor)
                    }
                }
                if let bgImageName = (dict["background"] as? [String: Any])?["backgroundImageName"] as? String {
                    DispatchQueue.main.async {
                        self.settings.background.backgroundImageName = bgImageName
                        self.backgroundImageName = bgImageName
                    }
                } else {
                    DispatchQueue.main.async {
                        self.settings.background.backgroundImageName = nil
                        self.backgroundImageName = nil
                    }
                }
                
                // ヘッダー設定
                if let headerDict = dict["header"] as? [String: Any],
                   let headerColor = headerDict["headerColor"] as? String,
                   let headerText = headerDict["headerText"] as? String {
                    DispatchQueue.main.async {
                        self.settings.header.headerColor = headerColor
                        self.headerColor = Color(hex: headerColor)
                        self.headerText = headerText
                    }
                }
                if let headerImageName = (dict["header"] as? [String: Any])?["headerImageName"] as? String {
                    DispatchQueue.main.async {
                        self.settings.header.headerImageName = headerImageName
                        self.headerImageName = headerImageName
                    }
                } else {
                    DispatchQueue.main.async {
                        self.settings.header.headerImageName = nil
                        self.headerImageName = nil
                    }
                }
                
                // ボタン設定
                if let buttonDict = dict["button"] as? [String: Any],
                   let buttonColor = buttonDict["buttonColor"] as? String {
                    DispatchQueue.main.async {
                        self.settings.button.buttonColor = buttonColor
                        self.buttonColor = Color(hex: buttonColor)
                    }
                }
                if let buttonImageName = (dict["button"] as? [String: Any])?["buttonImageName"] as? String {
                    DispatchQueue.main.async {
                        self.settings.button.buttonImageName = buttonImageName
                        self.buttonImageName = buttonImageName
                    }
                } else {
                    DispatchQueue.main.async {
                        self.settings.button.buttonImageName = nil
                        self.buttonImageName = nil
                    }
                }
                
                // 投稿一覧設定
                if let postListDict = dict["postList"] as? [String: Any],
                   let postListColor = postListDict["postListColor"] as? String,
                   let isReorder = postListDict["isReorderEnabled"] as? Bool {
                    DispatchQueue.main.async {
                        self.settings.postList.postListColor = postListColor
                        self.postListColor = Color(hex: postListColor)
                        self.isReorderEnabled = isReorder
                    }
                }
                if let postListImageName = (dict["postList"] as? [String: Any])?["postListImageName"] as? String {
                    DispatchQueue.main.async {
                        self.settings.postList.postListImageName = postListImageName
                        self.postListImageName = postListImageName
                    }
                } else {
                    DispatchQueue.main.async {
                        self.settings.postList.postListImageName = nil
                        self.postListImageName = nil
                    }
                }
            } else {
                // 設定が存在しない場合はデフォルト値を設定
                DispatchQueue.main.async {
                    self.settings = UserSettings()
                    self.backgroundColor = .white
                    self.backgroundImageName = nil
                    self.headerColor = .white
                    self.headerImageName = nil
                    self.headerText = "TODO一覧"
                    self.buttonColor = .white
                    self.buttonImageName = nil
                    self.postListColor = .white
                    self.postListImageName = nil
                    self.isReorderEnabled = true
                }
            }
        })
    }
    
    /// 背景色を更新
    func updateBackgroundColor(_ color: Color) {
        guard let hexString = color.toHex() else {
            return
        }
        settings.background.backgroundColor = hexString
        backgroundColor = color // Colorプロパティを更新
        ref.child("background/backgroundColor").setValue(hexString) { error, _ in
            if let error = error {
                print("Failed to update backgroundColor: \(error.localizedDescription)")
            } else {
                print("Successfully updated backgroundColor to \(hexString)")
            }
        }
    }
    
    /// 背景画像を更新
    func updateBackgroundImage(named imageName: String) {
        settings.background.backgroundImageName = imageName
        backgroundImageName = imageName
        ref.child("background/backgroundImageName").setValue(imageName) { error, _ in
            if let error = error {
                print("Failed to update backgroundImageName: \(error.localizedDescription)")
            } else {
                print("Successfully updated backgroundImageName to \(imageName)")
            }
        }
    }
    
    /// 背景画像をクリア
    func clearBackgroundImage() {
        settings.background.backgroundImageName = nil
        backgroundImageName = nil
        ref.child("background/backgroundImageName").removeValue { error, _ in
            if let error = error {
                print("Failed to clear backgroundImageName: \(error.localizedDescription)")
            } else {
                print("Successfully cleared backgroundImageName")
            }
        }
    }
    
    /// ヘッダー色を更新
    func updateHeaderColor(_ color: Color) {
        guard let hexString = color.toHex() else {
            return
        }
        settings.header.headerColor = hexString
        headerColor = color
        ref.child("header/headerColor").setValue(hexString) { error, _ in
            if let error = error {
                print("Failed to update headerColor: \(error.localizedDescription)")
            } else {
                print("Successfully updated headerColor to \(hexString)")
            }
        }
    }
    
    func updateHeaderTextColor(_ color: Color) {
        guard let hexString = color.toHex() else { return }
        settings.header.headerTextColor = hexString
        ref.child("header/headerTextColor").setValue(hexString) { error, _ in
            if let error = error {
                print("Failed to update headerTextColor: \(error.localizedDescription)")
            } else {
                print("Successfully updated headerTextColor to \(hexString)")
            }
        }
    }
    
    /// ヘッダー画像を更新
    func updateHeaderImage(named imageName: String) {
        settings.header.headerImageName = imageName
        headerImageName = imageName
        ref.child("header/headerImageName").setValue(imageName) { error, _ in
            if let error = error {
                print("Failed to update headerImageName: \(error.localizedDescription)")
            } else {
                print("Successfully updated headerImageName to \(imageName)")
            }
        }
    }
    
    /// ヘッダー画像をクリア
    func clearHeaderImage() {
        settings.header.headerImageName = nil
        headerImageName = nil
        ref.child("header/headerImageName").removeValue { error, _ in
            if let error = error {
                print("Failed to clear headerImageName: \(error.localizedDescription)")
            } else {
                print("Successfully cleared headerImageName")
            }
        }
    }
    
    /// ヘッダーのテキストを更新
    func updateHeaderText(_ text: String) {
        settings.header.headerText = text
        ref.child("header/headerText").setValue(text) { error, _ in
            if let error = error {
                print("Failed to update headerText: \(error.localizedDescription)")
            } else {
                print("Successfully updated headerText to \(text)")
            }
        }
    }
    
    /// ボタン色を更新
    func updateButtonColor(_ color: Color) {
        guard let hexString = color.toHex() else {
            return
        }
        settings.button.buttonColor = hexString
        buttonColor = color
        ref.child("button/buttonColor").setValue(hexString) { error, _ in
            if let error = error {
                print("Failed to update buttonColor: \(error.localizedDescription)")
            } else {
                print("Successfully updated buttonColor to \(hexString)")
            }
        }
    }
    
    /// ボタン画像を更新
    func updateButtonImage(named imageName: String) {
        settings.button.buttonImageName = imageName
        buttonImageName = imageName
        ref.child("button/buttonImageName").setValue(imageName) { error, _ in
            if let error = error {
                print("Failed to update buttonImageName: \(error.localizedDescription)")
            } else {
                print("Successfully updated buttonImageName to \(imageName)")
            }
        }
    }
    
    /// ボタン画像をクリア
    func clearButtonImage() {
        settings.button.buttonImageName = nil
        buttonImageName = nil
        ref.child("button/buttonImageName").removeValue { error, _ in
            if let error = error {
                print("Failed to clear buttonImageName: \(error.localizedDescription)")
            } else {
                print("Successfully cleared buttonImageName")
            }
        }
    }
    
    /// 投稿一覧色を更新
    func updatePostListColor(_ color: Color) {
        guard let hexString = color.toHex() else {
            return
        }
        settings.postList.postListColor = hexString
        postListColor = color
        ref.child("postList/postListColor").setValue(hexString) { error, _ in
            if let error = error {
                print("Failed to update postListColor: \(error.localizedDescription)")
            } else {
                print("Successfully updated postListColor to \(hexString)")
            }
        }
    }
    
    /// 投稿一覧画像を更新
    func updatePostListImage(named imageName: String) {
        settings.postList.postListImageName = imageName
        postListImageName = imageName
        ref.child("postList/postListImageName").setValue(imageName) { error, _ in
            if let error = error {
                print("Failed to update postListImageName: \(error.localizedDescription)")
            } else {
                print("Successfully updated postListImageName to \(imageName)")
            }
        }
    }
    
    /// 投稿一覧画像をクリア
    func clearPostListImage() {
        settings.postList.postListImageName = nil
        postListImageName = nil
        ref.child("postList/postListImageName").removeValue { error, _ in
            if let error = error {
                print("Failed to clear postListImageName: \(error.localizedDescription)")
            } else {
                print("Successfully cleared postListImageName")
            }
        }
    }
    
    /// 投稿一覧の並び替え機能を更新
    func updatePostListReorderEnabled(_ isEnabled: Bool) {
        settings.postList.isReorderEnabled = isEnabled
        isReorderEnabled = isEnabled
        ref.child("postList/isReorderEnabled").setValue(isEnabled) { error, _ in
            if let error = error {
                print("Failed to update isReorderEnabled: \(error.localizedDescription)")
            } else {
                print("Successfully updated isReorderEnabled to \(isEnabled)")
            }
        }
    }
}
