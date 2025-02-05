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
    var headerOpacityFlag: Bool
}

struct ButtonSettings: Codable {
    var buttonColor: String // Hex string
    var buttonImageName: String? // Optional: Image name from assets
}

struct PostListSettings: Codable {
    var postListColor: String // Hex string
    var postListImageName: String? // Optional: Image name from assets
    var postListTextColor: String // Hex string
    var isReorderEnabled: Bool // 並び替え機能の有効化
    var postListOpacityFlag: Bool
}

struct PlusButtonSettings: Codable { // 新規追加
    var plusButtonColor: String // Hex string
    var plusButtonImageName: String? // Optional: Image name from assets
}

// メインのユーザー設定モデル
struct UserSettings: Codable {
    var background: BackgroundSettings
    var header: HeaderSettings
    var button: ButtonSettings
    var postList: PostListSettings
    var plusButton: PlusButtonSettings
    
    init(
        background: BackgroundSettings = BackgroundSettings(backgroundColor: "#FFFFFF", backgroundImageName: nil),
        header: HeaderSettings = HeaderSettings(headerColor: "#FFFFFF", headerImageName: nil, headerText: "TODO一覧", headerTextColor: "#000000", headerOpacityFlag: false),
        button: ButtonSettings = ButtonSettings(buttonColor: "#FFFFFF", buttonImageName: nil),
        postList: PostListSettings = PostListSettings(postListColor: "#FFFFFF", postListImageName: nil, postListTextColor: "#000000", isReorderEnabled: true, postListOpacityFlag: false),
        plusButton: PlusButtonSettings = PlusButtonSettings(plusButtonColor: "#000000", plusButtonImageName: nil)
    ) {
        self.background = background
        self.header = header
        self.button = button
        self.postList = postList
        self.plusButton = plusButton
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
    @Published var headerOpacityFlag: Bool = false
    @Published var buttonColor: Color = .white
    @Published var buttonImageName: String? = nil
    @Published var postListColor: Color = .white
    @Published var postListTextColor: Color = .black
    @Published var postListImageName: String? = nil
    @Published var postListOpacityFlag: Bool = false
    @Published var isReorderEnabled: Bool = true
    @Published var plusButtonColor: Color = .black
    @Published var plusButtonImageName: String? = nil
    @Published var presets: [String: UserSettings] = [:]
    
    private var ref: DatabaseReference
    private var handle: DatabaseHandle?
    private var userID: String
    
    init(userID: String, mockSettings: UserSettings? = nil) {
        self.userID = userID
        self.ref = Database.database().reference().child("users").child(userID).child("settings")
        if let mock = mockSettings {
            self.settings = mock
            self.backgroundColor = Color(hex: mock.background.backgroundColor)
            self.backgroundImageName = mock.background.backgroundImageName
            self.headerColor = Color(hex: mock.header.headerColor)
            self.headerImageName = mock.header.headerImageName
            self.headerText = mock.header.headerText
            self.headerTextColor = Color(hex: mock.header.headerTextColor)
            self.headerOpacityFlag = mock.header.headerOpacityFlag
            self.buttonColor = Color(hex: mock.button.buttonColor)
            self.buttonImageName = mock.button.buttonImageName
            self.postListColor = Color(hex: mock.postList.postListColor)
            self.postListImageName = mock.postList.postListImageName
            self.postListOpacityFlag = mock.postList.postListOpacityFlag
            self.isReorderEnabled = mock.postList.isReorderEnabled
            self.postListTextColor = Color(hex: mock.postList.postListTextColor)
            self.plusButtonColor = Color(hex: mock.plusButton.plusButtonColor)
            self.plusButtonImageName = mock.plusButton.plusButtonImageName
        } else {
            // 初期設定
            self.settings = UserSettings()
            self.fetchSettings()
            self.fetchPresets()
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
//                   let headerColor = headerDict["headerColor"] as? String,
                   let headerText = headerDict["headerText"] as? String,
                   let headerTextColorHex = headerDict["headerTextColor"] as? String,
                   let headerOpacityFlag = headerDict["headerOpacityFlag"] as? Bool{
                    DispatchQueue.main.async {
                        self.headerText = headerText
                        self.headerTextColor = Color(hex: headerTextColorHex)
                        self.headerOpacityFlag = headerOpacityFlag
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
                
                // 投稿一覧設定
                if let postListDict = dict["postList"] as? [String: Any],
                   let postListColor = postListDict["postListColor"] as? String,
                   let postListTextColor = postListDict["postListTextColor"] as? String,
                   let postListOpacityFlag = postListDict["postListOpacityFlag"] as? Bool {
                    DispatchQueue.main.async {
                        self.settings.postList.postListColor = postListColor
                        self.postListColor = Color(hex: postListColor)
                        self.postListTextColor = Color(hex: postListTextColor)
                        self.postListOpacityFlag = postListOpacityFlag
                        print("self.postListOpacityFlag1     :\(self.postListOpacityFlag)")
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
                
                if let plusButtonDict = dict["plusButton"] as? [String: Any],
                      let plusButtonColorHex = plusButtonDict["plusButtonColor"] as? String {
                       DispatchQueue.main.async {
                           self.settings.plusButton.plusButtonColor = plusButtonColorHex
                           self.plusButtonColor = Color(hex: plusButtonColorHex)
                           print("プラスボタン色を更新: \(plusButtonColorHex)")
                       }
                   }
                   if let plusButtonImageName = (dict["plusButton"] as? [String: Any])?["plusButtonImageName"] as? String {
                       DispatchQueue.main.async {
                           self.settings.plusButton.plusButtonImageName = plusButtonImageName
                           self.plusButtonImageName = plusButtonImageName
                           print("プラスボタン画像を更新: \(plusButtonImageName)")
                       }
                   } else {
                       DispatchQueue.main.async {
                           self.settings.plusButton.plusButtonImageName = nil
                           self.plusButtonImageName = nil
                           print("プラスボタン画像をクリア")
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
                    self.headerTextColor = .black
                    self.headerOpacityFlag = false
                    self.buttonColor = .white
                    self.buttonImageName = nil
                    self.postListColor = .white
                    self.postListImageName = nil
                    self.isReorderEnabled = true
                    self.postListTextColor = .black
                    self.postListOpacityFlag = false
                    self.plusButtonColor = .black
                    self.plusButtonImageName = nil
                    print("設定が存在しないため、デフォルト値を適用")
                }
            }
        })
    }
    
    func fetchPresets() {
        // presets 以下に保存したデータを一度取得する
        ref.child("presets").observeSingleEvent(of: .value) { snapshot in
            var newPresets: [String: UserSettings] = [:]
            if let dict = snapshot.value as? [String: Any] {
                for (presetName, presetData) in dict {
                    // 各プリセット情報を JSON -> UserSettings にデコード
                    if let presetDict = presetData as? [String: Any],
                       let jsonData = try? JSONSerialization.data(withJSONObject: presetDict, options: []),
                       let userSettings = try? JSONDecoder().decode(UserSettings.self, from: jsonData) {
                        newPresets[presetName] = userSettings
                    }
                }
            }
            DispatchQueue.main.async {
                self.presets = newPresets
            }
        }
    }
    
    func loadPreset(name: String) {
        ref.child("presets").child(name).observeSingleEvent(of: .value) { snapshot in
            if let presetDict = snapshot.value as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: presetDict, options: []),
               let userSettings = try? JSONDecoder().decode(UserSettings.self, from: jsonData) {
                DispatchQueue.main.async {
                    // ViewModel内の各プロパティを更新
                    self.settings = userSettings
                    self.backgroundColor = Color(hex: userSettings.background.backgroundColor)
                    self.backgroundImageName = userSettings.background.backgroundImageName
                    
                    self.headerColor = Color(hex: userSettings.header.headerColor)
                    self.headerImageName = userSettings.header.headerImageName
                    self.headerText = userSettings.header.headerText
                    self.headerTextColor = Color(hex: userSettings.header.headerTextColor)
                    self.headerOpacityFlag = userSettings.header.headerOpacityFlag
                    
                    self.buttonColor = Color(hex: userSettings.button.buttonColor)
                    self.buttonImageName = userSettings.button.buttonImageName
                    
                    self.postListColor = Color(hex: userSettings.postList.postListColor)
                    self.postListImageName = userSettings.postList.postListImageName
                    self.postListTextColor = Color(hex: userSettings.postList.postListTextColor)
                    self.isReorderEnabled = userSettings.postList.isReorderEnabled
                    self.postListOpacityFlag = userSettings.postList.postListOpacityFlag
                    
                    self.plusButtonColor = Color(hex: userSettings.plusButton.plusButtonColor)
                    self.plusButtonImageName = userSettings.plusButton.plusButtonImageName
                    
                    // ここで preset の内容を settings テーブル直下に更新
                    if let data = try? JSONEncoder().encode(userSettings),
                       let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // updateChildValues() を使うと、既存の presets ノードはそのまま残ります。
                        self.ref.updateChildValues(dict) { error, _ in
                            if let error = error {
                                print("Preset適用に失敗しました: \(error.localizedDescription)")
                            } else {
                                print("Preset適用成功")
                            }
                        }
                    }
                }
            } else {
                print("Preset「\(name)」の読み込みに失敗しました")
            }
        }
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
    
    func savePreset(name: String) {
        let presetRef = ref.child("presets").child(name)
        do {
            // 現在の settings をエンコード
            let data = try JSONEncoder().encode(self.settings)
            // エンコードしたデータを Dictionary ([String: Any]) に変換
            if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Firebase に保存
                presetRef.setValue(dict) { error, _ in
                    if let error = error {
                        print("Presetの保存に失敗しました: \(error.localizedDescription)")
                    } else {
                        print("Preset「\(name)」を保存しました")
                    }
                }
            }
        } catch {
            print("Presetのエンコードに失敗しました: \(error.localizedDescription)")
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
    
    func updateHeaderOpacityFlag(_ bool: Bool) {
        settings.header.headerOpacityFlag = bool
        ref.child("header/headerOpacityFlag").setValue(bool) { error, _ in
            if let error = error {
                print("Failed to update headerText: \(error.localizedDescription)")
            } else {
                print("Successfully updated headerText to \(bool)")
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
        ref.child("plusButton/plusButtonColor").setValue(hexString) { error, _ in
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
        ref.child("plusButton/plusButtonImageName").setValue(imageName) { error, _ in
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
        ref.child("plusButton/plusButtonImageName").removeValue { error, _ in
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
    
    func updatePostListOpacityFlag(_ bool: Bool) {
        settings.postList.postListOpacityFlag = bool
        ref.child("postList/postListOpacityFlag").setValue(bool) { error, _ in
            if let error = error {
                print("Failed to update headerText: \(error.localizedDescription)")
            } else {
                print("Successfully updated headerText to \(bool)")
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
    
    func updateTodoTextColor(_ color: Color) {
        guard let hexString = color.toHex() else {
            return
        }
        settings.postList.postListTextColor = hexString
        postListTextColor = color
        ref.child("postList/postListTextColor").setValue(hexString) { error, _ in
            if let error = error {
                print("Failed to update todoTextColor: \(error.localizedDescription)")
            } else {
                print("Successfully updated todoTextColor to \(hexString)")
            }
        }
    }
    
    /// プラスボタンの色を更新 // 新規追加
    func updatePlusButtonColor(_ color: Color) {
        guard let hexString = color.toHex() else {
            return
        }
        settings.plusButton.plusButtonColor = hexString
        plusButtonColor = color
        ref.child("plusButton/plusButtonColor").setValue(hexString) { error, _ in
            if let error = error {
                print("Failed to update plusButtonColor: \(error.localizedDescription)")
            } else {
                print("Successfully updated plusButtonColor to \(hexString)")
            }
        }
    }
    
    /// プラスボタンの画像を更新 // 新規追加
    func updatePlusButtonImage(named imageName: String) {
        settings.plusButton.plusButtonImageName = imageName
        plusButtonImageName = imageName
        ref.child("plusButton/plusButtonImageName").setValue(imageName) { error, _ in
            if let error = error {
                print("Failed to update plusButtonImageName: \(error.localizedDescription)")
            } else {
                print("Successfully updated plusButtonImageName to \(imageName)")
            }
        }
    }
    
    /// プラスボタンの画像をクリア // 新規追加
    func clearPlusButtonImage() {
        settings.plusButton.plusButtonImageName = nil
        plusButtonImageName = nil
        ref.child("plusButton/plusButtonImageName").removeValue { error, _ in
            if let error = error {
                print("Failed to clear plusButtonImageName: \(error.localizedDescription)")
            } else {
                print("Successfully cleared plusButtonImageName")
            }
        }
    }
}
