//
//  ColorPickerView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI


// MARK: - Color Extension with Hex Initializer
extension Color {
    /// Converts a `Color` to its hex string representation.
    func toHex() -> String? {
        // Convert Color to UIColor
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
    
    /// Creates a `Color` from a hex string.
    /// - Parameter hex: The hex string, e.g., "#FFC1C1".
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
            // Default to white if invalid hex
            self = Color.white
        }
    }
}

// MARK: - ColorButton View
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
                    .frame(width: 40, height: 40)
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

// MARK: - SettingsView
struct ColorPickerView: View {
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @State private var selectedColorHex: String = "#FFFFFF" // 初期値は白
    @State private var pickedColor: Color = Color(hex: "#FFFFFF")
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
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Rectangle()
                        .frame(width:5, height: 20)
                        .foregroundColor(Color.black)
                    Text("背景色を選択")
                        .font(.headline)
                    Spacer()
                }
                
                // カラーボタンのグリッド
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                    ForEach(predefinedColorHexes, id: \.self) { hex in
                        ColorButton(
                            hex: hex,
                            selectedHex: selectedColorHex
                        ) {
                            selectedColorHex = hex
                            let selectedColor = Color(hex: hex)
                            userSettingsViewModel.updateBackgroundColor(selectedColor)
                        }
                    }
                }
                .padding()
                VStack(spacing: 10) {
                    HStack {
                        Rectangle()
                            .frame(width:5, height: 20)
                            .foregroundColor(Color.black)
                        Text("カラーピッカー")
                            .font(.headline)
                        Spacer()
                    }
                    
                    ColorPicker("カスタム色を選択", selection: $pickedColor)
                        .onChange(of: pickedColor) { newColor in
                            if let hex = newColor.toHex() {
                                selectedColorHex = hex
                                userSettingsViewModel.updateBackgroundColor(newColor)
                            }
                        }
                        .padding()
                }
                Spacer()
            }
            .padding()
            .onAppear {
                // 現在の背景色のHexコードを選択状態に反映
                selectedColorHex = userSettingsViewModel.settings.backgroundColor
                print("selectedColorHex :\(selectedColorHex)")
            }
        }
    }
}

#Preview {
    ColorPickerView(userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!))
}
