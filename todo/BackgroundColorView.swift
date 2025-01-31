//
//  ColorPickerView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

extension Color {
    /// HexコードからColorを初期化
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let cleanedHex = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        var rgb: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgb)
        
        let r, g, b: Double
        if cleanedHex.count == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            self = Color(red: r, green: g, blue: b)
        } else {
            // 無効なHexコードの場合は白色をデフォルトとする
            self = Color.white
        }
    }
    
    /// ColorをHexコードに変換
    func toHex() -> String? {
        // UIColorに変換
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let r = Int(red * 255)
            let g = Int(green * 255)
            let b = Int(blue * 255)
            return String(format: "#%02X%02X%02X", r, g, b)
        }
        return nil
    }
    
    /// ColorからRGBコンポーネントを取得
    func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue)
        }
        return nil
    }
}


struct ColorButton: View {
    let hex: String
    let selectedHex: String
    let action: () -> Void
    
    // Hexコードを基に選択状態を判定
    var isSelected: Bool {
        hex.lowercased() == selectedHex.lowercased()
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.black : Color.clear, lineWidth: 3)
                    )
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
    }
}

struct BackgroundColorView: View {
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @State private var selectedColorHex: String = "#FFFFFF" // 初期値は白
    @State private var pickedColor: Color = Color(hex: "#FFFFFF") // ColorPicker用の色
    
    // 事前定義された12色のHexコード
    let predefinedColorHexes: [String] = [
        "#FFC1C1", // Soft Red
        "#FFD8B1", // Soft Orange
        "#FFF5BA", // Soft Yellow
        "#C1FFC1", // Soft Green
        "#C1D4FF", // Soft Blue
        "#D1C1FF", // Soft Indigo
        "#E1C1FF", // Soft Purple
        "#FFC1F1", // Soft Pink
        "#E0E0E0", // Soft Gray
        "#D2B48C", // Soft Brown
        "#A1FFFF", // Soft Cyan
        "#A1FFC1"  // Soft Teal
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("背景色を選択")
                .font(.headline)
                .padding(.top)
            
            // カラーボタンのグリッド
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                ForEach(predefinedColorHexes, id: \.self) { hex in
                    ColorButton(
                        hex: hex,
                        selectedHex: selectedColorHex
                    ) {
                        // まず背景画像をクリア
                        if userSettingsViewModel.backgroundImageName != nil {
                            userSettingsViewModel.clearBackgroundImage()
                        }
                        
                        // その後、背景色を更新
                        selectedColorHex = hex
                        pickedColor = Color(hex: hex)
                        userSettingsViewModel.updateBackgroundColor(pickedColor)
                    }
                }
            }
            .padding()
            
            // カラーピッカーの追加
            VStack(spacing: 10) {
                Text("カラーピッカー")
                    .font(.headline)
                
                ColorPicker("カスタム色を選択", selection: $pickedColor)
                    .onChange(of: pickedColor) { newColor in
                        if let hex = newColor.toHex() {
                            // まず背景画像をクリア
                            if userSettingsViewModel.backgroundImageName != nil {
                                userSettingsViewModel.clearBackgroundImage()
                            }
                            
                            // その後、背景色を更新
                            selectedColorHex = hex
                            userSettingsViewModel.updateBackgroundColor(newColor)
                        }
                    }
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .background(Color("backgroundColor"))
        .onAppear {
            // 現在の背景色のHexコードを選択状態に反映
//            selectedColorHex = userSettingsViewModel.settings.backgroundColor
            pickedColor = Color(hex: selectedColorHex)
        }
    }
}

#Preview {
    BackgroundColorView(userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!))
}
