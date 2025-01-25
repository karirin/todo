//
//  AuthManager.swift
//  smallGaol
//
//  Created by Apple on 2024/03/22.
//

import SwiftUI
import Firebase

struct UserData {
    var id: String
    var createTime: String
    var tutorialNum: Int
    var userFlag: Int
    var selectedColor: String
}

class AuthManager: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var rewardPoint: Int = 0
    @Published var dateRangeText: String = ""
    @Published var userData: UserData?
    var onLoginCompleted: (() -> Void)?
    
    init() {
        user = Auth.auth().currentUser
    }
    
    var currentUserId: String? {
        print("user?.uid:\(user?.uid)")
        return user?.uid
    }
        
//    func createUser(completion: @escaping () -> Void) {
//        guard let userId = user?.uid else {
//            print("ユーザーがログインしていません")
//            completion() // 早期リターン時にもコールバックを呼ぶ
//            return
//        }
//        let userRef = Database.database().reference().child("users").child(userId)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        let currentDate = dateFormatter.string(from: Date())
//        
//        userRef.observeSingleEvent(of: .value) { snapshot in
//            if snapshot.exists() {
//                // ユーザーが既に存在する場合、特に何もしない
//            } else {
//                // 新しいユーザーを作成
//                userRef.setValue(["createTime": currentDate, "tutorialNum": 1]) { error, _ in
//                    DispatchQueue.main.async {
//                        if let error = error {
//                            print("ユーザー作成時にエラーが発生しました: \(error.localizedDescription)")
//                        } else {
//                            self.rewardPoint = 0
//                            print("新しいユーザーが作成されました。rewardPointは0からスタートします。")
//                            // サンプルデータの作成
//                            self.createSampleRewards(for: userId)
//                        }
//                        completion() // エラーの有無にかかわらず、処理完了後にコールバックを実行
//                    }
//                }
//            }
//        }
//    }

//    func createSampleRewards(for userId: String) {
//        let rewardsRef = Database.database().reference().child("rewards").child(userId)
//        
//        let sampleRewards = [
//            ["title": "【サンプル】旅行に行く", "amount": 25000, "icon": "ご褒美６", "flag": false],
//            ["title": "【サンプル】時計を買う", "amount": 200000, "icon": "ご褒美４", "flag": false]
//        ]
//        
//        for sampleReward in sampleRewards {
//            let newRewardRef = rewardsRef.childByAutoId()
//            newRewardRef.setValue(sampleReward) { error, _ in
//                if let error = error {
//                    print("サンプルご褒美の作成時にエラーが発生しました: \(error.localizedDescription)")
//                } else {
//                    print("サンプルご褒美が作成されました。")
//                }
//            }
//        }
//    }
    
    func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: dateString)
    }

    // 指定された日付から1週間の範囲の文字列を生成する
    func calculateDateRange(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d" // 表示形式

        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: date)!
        return "\(dateFormatter.string(from: date))〜\(dateFormatter.string(from: endDate))"
    }
    
    func fetchUserTimeAndCalculateRange(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("ユーザーがログインしていません")
            completion(false) // ユーザーIDが取得できなかった場合は、ここで処理を終了し、falseを返します。
            return
        }

        let userRef = Database.database().reference().child("users").child(userId)
        userRef.child("userTime").observeSingleEvent(of: .value) { snapshot in
            if let dateString = snapshot.value as? String, let date = self.parseDate(from: dateString) {
                let rangeText = self.calculateDateRange(from: date)
                DispatchQueue.main.async {
                    self.dateRangeText = rangeText
                    completion(true) // dateRangeTextに値がセットされたので、trueを返します。
                }
            } else {
                completion(false) // dateStringの取得または変換に失敗した場合は、falseを返します。
            }
        }
    }
    
    func fetchUserFlag(completion: @escaping (Int?, Error?) -> Void) {
        guard let userId = user?.uid else {
            // ユーザーIDがnilの場合、すなわちログインしていない場合
            let error = NSError(domain: "AuthManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "ログインしていません。"])
            completion(nil, error)
            return
        }

        let userRef = Database.database().reference().child("users").child(userId)
        // "userFlag"の値を取得する
        userRef.child("userFlag").observeSingleEvent(of: .value) { snapshot in
            if let userFlag = snapshot.value as? Int {
                // userFlagが存在し、Int型として取得できた場合
                DispatchQueue.main.async {
                    completion(userFlag, nil)
                }
            } else {
                // userFlagが存在しない、または想定外の形式である場合
                let error = NSError(domain: "AuthManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "userFlagを取得できませんでした。"])
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        } withCancel: { error in
            // データベースの読み取りに失敗した場合
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
    
    func anonymousSignIn(completion: @escaping () -> Void) {
        print("anonymousSignIn")
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let result = result {
                print("Signed in anonymously with user ID: \(result.user.uid)")
                self.user = result.user
                self.onLoginCompleted?()
            }
            completion()
        }
    }
    
    func updateTutorialNum(userId: String, tutorialNum: Int, completion: @escaping (Bool) -> Void) {
        let userRef = Database.database().reference().child("users").child(userId)
        let updates = ["tutorialNum": tutorialNum]
        userRef.updateChildValues(updates) { (error, _) in
            if let error = error {
                print("Error updating tutorialNum: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // tutorialNumを取得する関数
    func fetchTutorialNum(completion: @escaping (Int?, Error?) -> Void) {
        guard let userId = user?.uid else {
            print("fetchTutorialNum1")
            return
        }
        let userRef = Database.database().reference().child("users").child(userId)
        // "tutorialNum"の値を取得する
        userRef.child("tutorialNum").observeSingleEvent(of: .value) { snapshot in
            print("fetchTutorialNum1:\(snapshot)")
            // snapshotが存在し、Intとしてcastできる場合、その値をcompletionブロックに渡して返す
            if let tutorialNum = snapshot.value as? Int {
                DispatchQueue.main.async {
                    print("fetchTutorialNum2")
                    completion(tutorialNum, nil)
                }
            } else {
                // tutorialNumが存在しないか、適切な形式でない場合、エラーを返す
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "tutorialNumを取得できませんでした。"])
                DispatchQueue.main.async {
                    print("fetchTutorialNum3")
                    completion(nil, error)
                }
            }
        } withCancel: { error in
            // データベースの読み取りに失敗した場合、エラーを返す
            DispatchQueue.main.async {
                print("fetchTutorialNum4")
                completion(nil, error)
            }
        }
    }
    
    func updateContact(userId: String, newContact: String, completion: @escaping (Bool) -> Void) {
        // contactテーブルの下の指定されたuserIdの参照を取得
        let contactRef = Database.database().reference().child("contacts").child(userId)
        // まず現在のcontactの値を読み取る
        contactRef.observeSingleEvent(of: .value, with: { snapshot in
            // 既存の問い合わせ内容を保持する変数を準備
            var contacts: [String] = []
            
            // 現在の問い合わせ内容がある場合、それを読み込む
            if let currentContacts = snapshot.value as? [String] {
                contacts = currentContacts
            }
            
            // 新しい問い合わせ内容をリストに追加
            contacts.append(newContact)
            
            // データベースを更新する
            contactRef.setValue(contacts, withCompletionBlock: { error, _ in
                if let error = error {
                    print("Error updating contact: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            })
        }) { error in
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func deleteUserAccount(completion: @escaping (Bool, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = Database.database().reference().child("users").child(userId)
        userRef.removeValue { error, _ in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
    
//    func fetchUserData(completion: @escaping (Bool, Error?) -> Void) {
//        guard let userId = user?.uid else {
//            let error = NSError(domain: "AuthManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "ログインしていません。"])
//            completion(false, error)
//            return
//        }
//        
//        let userRef = Database.database().reference().child("users").child(userId)
//        userRef.observeSingleEvent(of: .value) { snapshot in
//            if let value = snapshot.value as? [String: Any] {
//                let userData = UserData(
//                    id: userId,
//                    createTime: value["createTime"] as? String ?? ""
//                )
//                self.userData = userData
//                print("self.userData:\(self.userData)")
//                completion(true, nil)
//            } else {
//                let error = NSError(domain: "AuthManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "ユーザーデータを取得できませんでした。"])
//                completion(false, error)
//            }
//        } withCancel: { error in
//            completion(false, error)
//        }
//    }
    
    func updateUserCsFlag(userId: String, userCsFlag: Int, completion: @escaping (Bool) -> Void) {
        let userRef = Database.database().reference().child("users").child(userId)
        let updates = ["userCsFlag": userCsFlag]
        print(updates)
        userRef.updateChildValues(updates) { (error, _) in
            if let error = error {
                print("Error updating tutorialNum: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    private func calculateNextSalaryDate(salaryDay: Int) -> Date? {
        var components = Calendar.current.dateComponents([.year, .month], from: Date())
        components.day = salaryDay
        
        if let salaryDateThisMonth = Calendar.current.date(from: components), salaryDateThisMonth > Date() {
            return salaryDateThisMonth
        } else {
            components.month = (components.month ?? 0) + 1
            return Calendar.current.date(from: components)
        }
    }
}

struct AuthManager1: View {
    @ObservedObject var authManager = AuthManager()

    var body: some View {
        VStack {
            if authManager.user == nil {
                Text("Not logged in")
            } else {
                Text("Logged in with user ID: \(authManager.user!.uid)")
            }
            Button(action: {
                if self.authManager.user == nil {
                    self.authManager.anonymousSignIn(){}
                }
            }) {
                Text("Log in anonymously")
            }
        }
    }
}

struct AuthManager_Previews: PreviewProvider {
    static var previews: some View {
        AuthManager1()
    }
}



