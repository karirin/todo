//
//  PreView.swift
//  todo
//
//  Created by Apple on 2025/02/12.
//

import SwiftUI
import StoreKit
import Combine

struct Feature: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

struct FeatureView: View {
    let feature: Feature

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(feature.title)
                .resizable()
                .scaledToFit()
                .frame(height: isSmallDevice() ? 132 : isiPhone12Or13() ? 136 : 140)
            HStack {
                    Spacer()
                    Image(systemName: feature.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(feature.title)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
            }
            .padding(.horizontal)
            Text(feature.description)
//                .font(.system(size: isSmallDevice() ? 12 : 18))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom)
                .padding(.horizontal)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 2)
        )
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
    
    func isiPhone12Or13() -> Bool {
        let screenSize = UIScreen.main.bounds.size
        let width = min(screenSize.width, screenSize.height)
        let height = max(screenSize.width, screenSize.height)
        // iPhone 12,13 の画面サイズは約幅390ポイント、高さ844ポイント
        return abs(width - 390) < 1 && abs(height - 844) < 1
    }
}

struct PreView: View {
    @State private var selectedPlan = 0
    @StateObject private var viewModel = SubscriptionViewModel()
    @StateObject var appState = AppState()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var currentIndex = 0
    @State private var timer: Timer? = nil
    @Binding var changeTitle: Int
    
    let features: [Feature] = [
        Feature(imageName: "crown",
                title: "カスタマイズ機能拡張",
                description: "カスタマイズの種類が214個→528個に"),
        Feature(imageName: "rectangle.badge.xmark",
                title: "広告非表示",
                description: "ホーム画面の広告が非表示化"),
        Feature(imageName: "bookmark",
                title: "保存機能",
                description: "保存できるカスタマイズが３つ以上可能に"),
        Feature(imageName: "crown",
                title: "カスタマイズ機能拡張",
                description: "カスタマイズの種類が214個→528個に")
        
    ]
    
    var body: some View {
        NavigationView {
            ZStack{
                if isSmallDevice() {
                    Image("プレミアムプラン背景SE")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Image("プレミアムプラン背景")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    // ヘッダー
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
//                                .foregroundColor(Color("fontGray"))
                            Text("戻る")
//                                .foregroundColor(Color("fontGray"))
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(30)
                        .padding(.leading)
                        Spacer()
//                        Text("プレミアムプラン")
//                            .font(.headline)
                        Spacer()
                        // レイアウトの対称性を保つために非表示のボタン
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("fontGray"))
                            Text("戻る")
                                .foregroundColor(Color("fontGray"))
                        }
                        .padding(.leading)
                        .opacity(0)
                    }
                    .padding(.top,10)
//                    .padding(.bottom, -10)
                    // ScrollView のコンテンツ
                    ScrollView {
                        ZStack{
                            
//                            Image("プレミアムプランエフェクト")
//                                .resizable()
//                                .scaledToFit()
//                                .padding(-40)
//                                .padding(.top, -200)
//                                .zIndex(1)
                        VStack{
                            if changeTitle == 1 {
                                Image("プレミアムプランタイトル1")
                                    .resizable()
                                    .scaledToFit().padding(.vertical,25)
                            } else if changeTitle == 2 {
                                Image("プレミアムプランタイトル2")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(5)
                                    .padding(.vertical,10)
                            } else if changeTitle == 3 {
                                Image("プレミアムプランタイトル3")
                                    .resizable()
                                    .scaledToFit().padding(.vertical,25)
                            }
////                                    .padding(.bottom, -70)
                                //                            HStack{
//                                Image("プレミアムプランロック")
//                                    .resizable()
//                                //                                    .scaledToFit()
//                                    .frame(height: 350)
//                                    .padding(.leading, -150)
//                                Image("プレミアムプランライム")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: 170)
//                                    .padding(.trailing, -200)
//                                    .padding(.leading, 60)
//                                    .padding(.bottom, -30)
                                //                            }
                            }
//                            .padding(.bottom,isSmallDevice() ? -100 : -70 )
                        }
                        .padding(.vertical, -30)
                        // キャッチフレーズ
                        HStack{
                            Spacer()
                            VStack(spacing: 5) {
                                Text("飲み物1本で")
                                HStack {
                                    Text("アプリをより便利に")
                                    Image(systemName: "arrow.up.forward")
                                        .padding(.leading, -10)
                                }
                            }
                            Spacer()
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.7))
                        
                        // 料金比較
                        HStack {
                            Spacer()
                            Text("　　　　　       ")
                            Spacer()
                            Text("通常")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                            Spacer()
                            Spacer()
                            Spacer()
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.red)
                                .padding(.trailing, -5)
                                .padding(.bottom, 2)
                            Text("プレミアム")
                                .font(.system(size: isSmallDevice() ? 16 : 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 5)
                        
                        // 特徴の比較
                        VStack {
                            HStack {
                                Text("カスタマイズ\n機能拡張")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                HStack{
                                    Spacer()
                                    Image(systemName: "xmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                HStack{
                                    Spacer()
                                    Image(systemName: "circle")
                                        .foregroundStyle(.red)
                                        .bold()
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            Rectangle()
                              .frame(height: 1)
                              .foregroundColor(Color.white)
                            HStack {
                                Text("広告非表示")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                HStack{
                                    Spacer()
                                    Image(systemName: "xmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                HStack{
                                    Spacer()
                                    Image(systemName: "circle")
                                        .foregroundStyle(.red)
                                        .bold()
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 5)
                            Rectangle()
                              .frame(height: 1)
                              .foregroundColor(Color.white)
                            
                            HStack {
                                Text("保存機能　")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                HStack{
                                    Spacer()
                                    Image(systemName: "xmark")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                HStack{
                                    Spacer()
                                    Image(systemName: "circle")
                                        .foregroundStyle(.red)
                                        .bold()
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 5)
                            .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        // 自動スクロール付きカルーセルセクション
                        TabView(selection: $currentIndex) {
                            ForEach(Array(features.enumerated()), id: \.1.id) { index, feature in
                                FeatureView(feature: feature)
                                    .frame(width: UIScreen.main.bounds.width * 0.9,height: 240)
                                    .padding(.horizontal, 10)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 230)
                        .onAppear {
                            startTimer()
                        }
                        .onDisappear {
                            stopTimer()
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { _ in
                                    stopTimer()
                                }
                                .onEnded { _ in
                                    startTimer()
                                }
                        )
                        
                        // ページインジケーターの追加
                        HStack(spacing: 8) {
                            ForEach(0..<features.count-1, id: \.self) { index in
                                Circle()
                                    .fill(index == (currentIndex == features.count - 1 ? 0 : currentIndex) ? Color.blue : Color.gray)
                                    .frame(width: 8, height: 8)
                                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
                            }
                        }.padding(.bottom)
                        
                        VStack{
                            // 購入復元と解約リンク
                            HStack {
                                Text("購入復元時は")
                                Button(action: {
                                    Task {
                                        do {
                                            try await AppStore.sync()
                                        } catch {
                                            print("購入処理中にエラーが発生しました: \(error)")
                                        }
                                    }
                                }) {
                                    Text("こちら　")
                                        .foregroundStyle(Color.blue)
                                }
                                Text("から")
                            }
                            HStack {
                                Text("解約時は")
                                NavigationLink(destination: WebView(urlString: "https://support.apple.com/ja-jp/HT202039")) {
                                    Text("こちら")
                                        .foregroundStyle(Color.blue)
                                }
                                Text("をご参考ください")
                            }
                            .padding(.top, 5)
                            
                            // 利用規約とプライバシーポリシーリンク
                            HStack {
                                Spacer()
                                NavigationLink(destination: TermsOfServiceView()) {
                                    Text("利用規約")
                                }
                                Spacer()
                                NavigationLink(destination: PrivacyView()) {
                                    Text("プライバシーポリシー")
                                }
                                Spacer()
                            }
                            .padding(.top, 5)
                            .foregroundStyle(Color.blue)
                        }
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.7))
                        .padding(.top, -20)
                    }
                    
                    // 購入セクション
                    VStack(spacing: 1) {
                        HStack {
                            Spacer()
                            HStack {
                                Text("月額 ¥")
                                    .foregroundStyle(.white)
                                    .bold()
                                    .padding(.top, 8)
                                Text("200")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30))
                                    .bold()
                                    .padding(.leading, -5)
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 10)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(10)
                        }
                        .padding(.top, 10)
                        .padding(.trailing)
                        .padding(.bottom,10)
                        ForEach(viewModel.products, id: \.id) { product in
                            Button(action: {
                                Task {
                                    do {
                                        try await AppStore.sync()
                                        try await viewModel.purchaseProduct(product, showAlert: $showAlert)
                                        appState.isBannerVisible = false
                                        alertMessage = "広告非表示の反映に少しお時間がかかる場合がございます。\nご了承ください"
                                    } catch StoreKitError.userCancelled {
                                        print("StoreKitError.userCancelled")
                                        // 必要に応じてメッセージを表示
                                    } catch {
                                        print("購入処理中にエラーが発生しました: \(error)")
                                    }
                                }
                            }) {
                                VStack {
                                    Text("プレミアムプランに登録する")
                                        .padding(.bottom, 1)
                                    Text("※いつでも解約することができます")
                                        .font(.system(size: 16))
                                }
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.black)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .padding(.horizontal,20)
                                .shadow(radius: 30)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("プレミアムプラン登録ありがとうございます！"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .foregroundColor(Color("fontGray"))
        .onAppear {
            Task {
                await viewModel.loadProducts()
            }
        }
    }
}
    
// カルーセルのタイマーと無限ループの実装
extension PreView {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            withAnimation {
                currentIndex += 1
            }
            
            // 無限ループの実装
            if currentIndex >= features.count {
                currentIndex = 0
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// ヘルパー関数
extension PreView {
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
    
    func fontSizeSE(for text: String, isIPad: Bool) -> CGFloat {
        let baseFontSize: CGFloat = isIPad ? 34 : 30
        
        let englishAlphabet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let textCharacterSet = CharacterSet(charactersIn: text)
        
        if englishAlphabet.isSuperset(of: textCharacterSet) {
            return baseFontSize
        } else {
            if text.count >= 14 {
                return baseFontSize - 12
            } else if text.count >= 12 {
                return baseFontSize - 10
            } else if text.count >= 10 {
                return baseFontSize - 8
            } else if text.count >= 8 {
                return baseFontSize - 6
            } else {
                return baseFontSize
            }
        }
    }
}

struct PreView_Previews: PreviewProvider {
    static var previews: some View {
        PreView(changeTitle: .constant(3))
    }
}

