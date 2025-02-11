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
    var backgroundImageName: String? // Optional: Image name from assets
}

struct HeaderSettings: Codable {
    var headerImageName: String?
    var headerText: String
    var headerTextColor: String // 新規追加: Hexコードで保存
    var headerOpacityFlag: Bool
}

struct PostListSettings: Codable {
    var postListImageName: String? // Optional: Image name from assets
    var postListTextColor: String // Hex string
    var postListOpacityFlag: Bool
}

struct PlusButtonSettings: Codable { // 新規追加
    var plusButtonImageName: String? // Optional: Image name from assets
}

// メインのユーザー設定モデル
struct UserSettings: Codable {
    var background: BackgroundSettings
    var header: HeaderSettings
    var postList: PostListSettings
    var plusButton: PlusButtonSettings
    
    init(
        background: BackgroundSettings = BackgroundSettings( backgroundImageName: nil),
        header: HeaderSettings = HeaderSettings(headerImageName: nil, headerText: "TODO一覧", headerTextColor: "#000000", headerOpacityFlag: false),
        postList: PostListSettings = PostListSettings(postListImageName: nil, postListTextColor: "#000000", postListOpacityFlag: false),
        plusButton: PlusButtonSettings = PlusButtonSettings(plusButtonImageName: nil)
    ) {
        self.background = background
        self.header = header
        self.postList = postList
        self.plusButton = plusButton
    }
}

class UserSettingsViewModel: ObservableObject {
    @Published var settings: UserSettings
    @Published var backgroundImageName: String? = nil
    @Published var headerImageName: String? = nil
    @Published var headerText: String = "TODO一覧"
    @Published var headerTextColor: Color = .black
    @Published var headerOpacityFlag: Bool = false
    @Published var postListTextColor: Color = .black
    @Published var postListImageName: String? = nil
    @Published var postListOpacityFlag: Bool = false
    @Published var plusButtonImageName: String? = nil
    @Published var presets: [String: UserSettings] = [:]
    @Published var isLoading: Bool = true
    
    private var ref: DatabaseReference
    private var handle: DatabaseHandle?
    private var userID: String
    
    init(mockSettings: UserSettings? = nil) {
        let currentUserId = AuthManager().currentUserId!
        self.userID = currentUserId
        ref = Database.database().reference().child("users").child(currentUserId).child("settings")
        if let mock = mockSettings {
            self.settings = mock
            self.backgroundImageName = mock.background.backgroundImageName
            self.headerImageName = mock.header.headerImageName
            self.headerText = mock.header.headerText
            self.headerTextColor = Color(hex: mock.header.headerTextColor)
            self.headerOpacityFlag = mock.header.headerOpacityFlag
            self.postListImageName = mock.postList.postListImageName
            self.postListOpacityFlag = mock.postList.postListOpacityFlag
            self.postListTextColor = Color(hex: mock.postList.postListTextColor)
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
                   let postListTextColor = postListDict["postListTextColor"] as? String,
                   let postListOpacityFlag = postListDict["postListOpacityFlag"] as? Bool {
                    DispatchQueue.main.async {
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
                    self.backgroundImageName = nil
                    self.headerImageName = nil
                    self.headerText = "TODO一覧"
                    self.headerTextColor = .black
                    self.headerOpacityFlag = false
                    self.postListImageName = nil
                    self.postListTextColor = .black
                    self.postListOpacityFlag = false
                    self.plusButtonImageName = nil
                    print("設定が存在しないため、デフォルト値を適用")
                }
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        })
    }
    
    func fetchPresets() {
        print("fetchPresets1")
        // presets 以下に保存したデータを一度取得する
        ref.child("presets").observeSingleEvent(of: .value) { snapshot in
            var newPresets: [String: UserSettings] = [:]
            print("fetchPresets2")
            if let dict = snapshot.value as? [String: Any] {
                print("fetchPresets3")
                for (presetName, presetData) in dict {
                    print("fetchPresets4")
                    // 各プリセット情報を JSON -> UserSettings にデコード
                    if let presetDict = presetData as? [String: Any],
                       let jsonData = try? JSONSerialization.data(withJSONObject: presetDict, options: []),
                       let userSettings = try? JSONDecoder().decode(UserSettings.self, from: jsonData) {
                        print("userSettings     :\(userSettings)")
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
                    self.backgroundImageName = userSettings.background.backgroundImageName
                    
                    self.headerImageName = userSettings.header.headerImageName
                    self.headerText = userSettings.header.headerText
                    self.headerTextColor = Color(hex: userSettings.header.headerTextColor)
                    self.headerOpacityFlag = userSettings.header.headerOpacityFlag
                    
                    self.postListImageName = userSettings.postList.postListImageName
                    self.postListTextColor = Color(hex: userSettings.postList.postListTextColor)
                    self.postListOpacityFlag = userSettings.postList.postListOpacityFlag
                    
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
    
    func savePreset() {
        // Firebaseのpushキーを自動生成
        let presetRef = ref.child("presets").childByAutoId()

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
                        print("Presetを自動生成キーで保存しました")
                    }
                }
            }
        } catch {
            print("Presetのエンコードに失敗しました: \(error.localizedDescription)")
        }
    }
    
    func deletePreset(name: String) {
        ref.child("presets").child(name).removeValue { error, _ in
            if let error = error {
                print("Preset「\(name)」削除に失敗: \(error.localizedDescription)")
            } else {
                print("Preset「\(name)」を削除しました")
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
