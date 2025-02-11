//
//  SettingView.swift
//  Goal
//
//  Created by hashimo ryoya on 2023/06/10.
//

import SwiftUI
import WebKit

struct OtherApp: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let appStoreLink: String
}

extension OtherApp {
    static let allApps = [
        OtherApp(name: "サラリー｜お給料管理アプリ", description: "月の給料日まで自分がどれくらい稼いでいるか確認できて、仕事のモチベーションを上げることができるアプリです。", appStoreLink: "https://apps.apple.com/us/app/%E3%82%B5%E3%83%A9%E3%83%AA%E3%83%BC-%E3%81%8A%E7%B5%A6%E6%96%99%E7%AE%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id6670354348"),
        OtherApp(name: "AIトーク チャットモ", description: "AIを搭載した可愛いキャラクターと会話して楽しむことができます。会話を重ねると親密度が上げていくことができます。", appStoreLink: "https://apps.apple.com/us/app/ai%E3%83%88%E3%83%BC%E3%82%AF-%E3%83%81%E3%83%A3%E3%83%83%E3%83%88%E3%83%A2/id6478230196"),
        OtherApp(name: "シュウカン|習慣支援アプリ", description: "1週間の習慣をサポートするアプリです。「本を1冊読む」や「3時間勉強する」など1週間の習慣を決めて、進捗があれば記録をしていきます。", appStoreLink: "https://apps.apple.com/us/app/%E3%82%B7%E3%83%A5%E3%82%A6%E3%82%AB%E3%83%B3-%E7%BF%92%E6%85%A3%E6%94%AF%E6%8F%B4%E3%82%A2%E3%83%97%E3%83%AA/id6480456838"),
        OtherApp(name: "ITクエスト", description: "ゲーム感覚でITの知識が学べるアプリ。『ITパスポート』『基本情報技術者試験』『応用技術者試験』などIT周りの勉強をゲーム感覚で学べます。", appStoreLink: "https://apps.apple.com/us/app/it%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88-it%E3%81%A8%E5%95%8F%E9%A1%8C%E3%81%A8%E5%8B%89%E5%BC%B7%E3%81%A8%E5%AD%A6%E7%BF%92%E3%81%8C%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%A2%E3%83%97%E3%83%AA/id6469339499"),
        OtherApp(name: "FPクエスト", description: "ゲーム感覚でお金の知識が学べるアプリ。税金、投資、節約、予算管理などお金周りの勉強をゲーム感覚で学べます。", appStoreLink: "https://apps.apple.com/us/app/%E3%81%8A%E9%87%91%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88/id6476828253"),
        OtherApp(name: "英語クエスト", description: "ゲーム感覚で英語の知識が学べるアプリ。「英単語」「英熟語」「英文法」に分かれており、それぞれ『英検』『TOIEC』の難易度別に勉強をゲーム感覚で学べます。", appStoreLink: "https://apps.apple.com/us/app/%E8%8B%B1%E8%AA%9E%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88-%E8%8B%B1%E8%AA%9E%E3%81%AE%E5%95%8F%E9%A1%8C%E3%81%AE%E5%8B%89%E5%BC%B7%E3%81%A8%E5%AD%A6%E7%BF%92%E3%81%8C%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%A2%E3%83%97%E3%83%AA/id6477769441"),
    ]
}

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isSoundOn: Bool = true
    @ObservedObject var authManager = AuthManager()
    @State private var showingDeleteAlert = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("情報")) {
                    NavigationLink(destination: TermsOfServiceView()) {
                        HStack {
                            Text("利用規約")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.systemGray4))
                        }
                    }
                    
                    NavigationLink(destination: PrivacyView()) {
                        HStack {
                            Text("プライバシーポリシー")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.systemGray4))
                        }
                    }
                    
                    NavigationLink(destination: WebView(urlString: "https://docs.google.com/forms/d/e/1FAIpQLSfHxhubkEjUw_gexZtQGU8ujZROUgBkBcIhB3R6b8KZpKtOEQ/viewform?embedded=true")) {
                        HStack {
                            Text("お問い合せ")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.systemGray4))
                        }
                    }
//                    if authManager.adminFlag == 1 {
//                    NavigationLink(destination: SubscriptionView(audioManager: audioManager).navigationBarBackButtonHidden(true)) {
//                        HStack {
//                            Text("広告を非表示にする")
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(Color(.systemGray4))
//                        }
//                    }
                    Button("アカウントを削除") {
                        showingDeleteAlert = true
                    }
                    .foregroundColor(.red)
                    .alert("アカウントを削除してもよろしいですか？この操作は元に戻せません。", isPresented: $showingDeleteAlert) {
                        Button("削除", role: .destructive) {
                            authManager.deleteUserAccount { success, error in
                                if success {
                                    // アカウント削除成功時の処理
                                } else {
                                    // エラー処理
                                }
                            }
                        }
                        Button("キャンセル", role: .cancel) {}
                    }
//                    }
//                    NavigationLink(destination: Interstitial1()) {
//                        HStack {
//                            Text("インタースティシャル")
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(Color(.systemGray4))
//                        }
//                    }
                }
                Section(header: Text("他のアプリ")) {
//                    ScrollView{
                        ForEach(OtherApp.allApps) { app in
                            Link(destination: URL(string: app.appStoreLink)!) {
                                
                                HStack {
                                    Image("\(app.name)")
                                        .resizable()
                                        .frame(width:80,height: 80)
                                        .cornerRadius(10)
                                    VStack(alignment: .leading) {
                                        Text(app.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text(app.description)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.black)
                                    }
                                }
                            }
//                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("設定")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(leading: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("fontGray"))
                            Text("戻る")
                                .foregroundColor(Color("fontGray"))
                        })
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
