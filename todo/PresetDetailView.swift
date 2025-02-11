//
//  PresetDetailView.swift
//  todo
//
//  Created by Apple on 2025/02/06.
//

import SwiftUI

struct PresetDetailView: View {
    // ① 表示したいプリセットデータを受け取る
    let preset: UserSettings
    
    var body: some View {
        VStack(spacing: 10) {
            // ② ヘッダー部の表示
            if let headerImageName = preset.header.headerImageName,
               let uiHeaderImage = UIImage(named: headerImageName) {
                Image(uiImage: uiHeaderImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 20)
                    .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                    .padding(.bottom, -30)
                    .padding(.top, 20)
                    .zIndex(1)
            } else {
                Color(hex: preset.header.headerColor)  // カスタムのColor拡張でhexを変換
                    .frame(height: 20)
                    .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                    .padding(.bottom, -30)
                    .padding(.top, 20)
                    .zIndex(1)
            }
            
            // ③ 背景画像 or 背景色
            ZStack {
                if let bgImageName = preset.background.backgroundImageName,
                   let uiImage = UIImage(named: bgImageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 210)
                        .clipShape(RoundedCorner(radius: 10))
                } else {
                    Color(hex: preset.background.backgroundColor)
                        .frame(height: 210)
                        .clipShape(RoundedCorner(radius: 10))
                }
                
                // ④ 投稿一覧の背景（画像 or 色）
                if let postListImageName = preset.postList.postListImageName,
                   let uiPostListImage = UIImage(named: postListImageName) {
                    VStack {
                        Image(uiImage: uiPostListImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Image(uiImage: uiPostListImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Spacer()
                    }
                    .padding(10)
                    .padding(.top)
                } else {
                    VStack {
                        Color(hex: preset.postList.postListColor)
                            .frame(height: 20)
                        Color(hex: preset.postList.postListColor)
                            .frame(height: 20)
                        Spacer()
                    }
                    .padding(10)
                    .padding(.top)
                }
                
                // ⑤ プラスボタン表示（画像 or 色付き）
                if let plusImageName = preset.plusButton.plusButtonImageName,
                   let uiPlusImage = UIImage(named: plusImageName) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(uiImage: uiPlusImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .padding(.top, -20)
                        }
                        .padding(.bottom, 30)
                        .padding(.trailing, 10)
                    }
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "plus")
                                .font(.system(size: 15))
                                .padding(5)
                                .background(Color(hex: preset.plusButton.plusButtonColor))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding(.top, -20)
                        }
                        .padding(.bottom, 30)
                        .padding(.trailing, 10)
                    }
                }
            }
        }
        .frame(width: 100, height: 250)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.top, -10)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanString.hasPrefix("#") {
            cleanString.removeFirst()
        }
        if cleanString.count == 6 {
            cleanString.append("FF") // 不透明度FFをデフォルトに
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cleanString).scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(rgbValue & 0x000000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

struct PresetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PresetEditorView(userSettingsViewModel: UserSettingsViewModel())
    }
}
