//
//  BackgroundImageView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

struct ColorCategory: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct BackgroundImageView: View {
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @State private var selectedImageName: String? = nil
    @State private var selectedCategory: ColorCategory? = nil
    @State private var selectedColor: Color = Color.white
    @State private var filteredImageNames: [String] = []
    @State private var isColorSheetPresented: Bool = false

    let predefinedBackgroundImageNames: [String] = [
        "紫1", "紫2", "紫3", "紫4", "紫5", "紫6", "紫7", "紫8", "紫9", "紫10",
        "青1", "青2", "青3", "青4", "青5", "青6", "青7", "青8", "青9", "青10",
        "水1", "水2", "水3", "水4", "水5", "水6", "水7", "水8", "水9", "水10",
        "薄水1", "薄水2", "薄水3", "薄水4", "薄水5", "薄水6", "薄水7", "薄水8", "薄水9", "薄水10",
        "黄1", "黄2", "黄3", "黄4", "黄5", "黄6", "黄7", "黄8", "黄9", "黄10",
        "薄緑1", "薄緑2", "薄緑3", "薄緑4", "薄緑5", "薄緑6", "薄緑7", "薄緑8", "薄緑9", "薄緑10",
        "緑1", "緑2", "緑3", "緑4", "緑5", "緑6", "緑7", "緑8", "緑9", "緑10",
        "赤1", "赤2", "赤3", "赤4", "赤5", "赤6", "赤7", "赤8", "赤9", "赤10",
        "橙1", "橙2", "橙3", "橙4", "橙5", "橙6", "橙7", "橙8", "橙9", "橙10",
        "桃1", "桃2", "桃3", "桃4", "桃5", "桃6", "桃7", "桃8", "桃9", "桃10",
        "黒1", "黒2", "黒3", "黒4", "黒5", "黒6", "黒7", "黒8", "黒9", "黒10",
        "灰1", "灰2", "灰3", "灰4", "灰5", "灰6", "灰7", "灰8", "灰9", "灰10",
        "白1", "白2", "白3", "白4", "白5", "白6", "白7", "白8", "白9", "白10",
    ]
    
    let colorCategories: [ColorCategory] = [
        ColorCategory(name: "黄", color: Color(hex: "#FFFF00")),    // Yellow
        ColorCategory(name: "黄緑", color: Color(hex: "#ADFF2F")),  // YellowGreen
        ColorCategory(name: "灰", color: Color(hex: "#808080")),    // Gray
        ColorCategory(name: "水", color: Color(hex: "#00BFFF")),    // DeepSkyBlue
        ColorCategory(name: "薄水", color: Color(hex: "#87CEFA")),  // LightSkyBlue
        ColorCategory(name: "青", color: Color(hex: "#0000FF")),    // Blue
        ColorCategory(name: "緑", color: Color(hex: "#008000")),    // Green
        
        // 追加する色カテゴリ
        ColorCategory(name: "紫", color: Color(hex: "#800080")),    // Purple
        ColorCategory(name: "赤", color: Color(hex: "#FF0000")),    // Red
        ColorCategory(name: "橙", color: Color(hex: "#FFA500")),    // Orange
        ColorCategory(name: "桃", color: Color(hex: "#FFDAB9")),    // Peach
        ColorCategory(name: "黒", color: Color(hex: "#000000")),    // Black
        ColorCategory(name: "白", color: Color(hex: "#FFFFFF")),    // White
    ]
        
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        isColorSheetPresented = true
                    }) {
                        HStack {
                            Image(systemName: "paintpalette")
                                .padding(.trailing, -5)
                            Text("色で探す")
                        }
                        .padding(5)
                        .foregroundColor(.gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }.opacity(0)
                    Spacer()
                    Text("背景を選択")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        isColorSheetPresented = true
                    }) {
                        HStack {
                            Image(systemName: "paintpalette")
                                .padding(.trailing, -5)
                            Text("色で探す")
                        }
                        .padding(5)
                        .foregroundColor(.gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
                
                // 事前定義された背景画像のグリッド
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                    
                    Button(action: {
                        withAnimation {
                            userSettingsViewModel.clearBackgroundImage()
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.secondarySystemBackground))
                                .frame(height: 226)
                            
                            VStack {
                                Text("背景無し")
                                    .foregroundColor(.black)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    }
                    
                    ForEach(filteredImageNames, id: \.self) { imageName in
                        Button(action: {
                            withAnimation {
                                // 事前定義された画像を選択
                                userSettingsViewModel.updateBackgroundImage(named: imageName)
                                
                                // 背景色をデフォルトに戻す
                                userSettingsViewModel.updateBackgroundColor(Color(hex: "#FFFFFF"))
                            
                            }
                        }) {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(10)
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(userSettingsViewModel.backgroundImageName == imageName ? Color.black : Color.clear, lineWidth: 4)
                                )
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .background(Color("backgroundColor"))
        .onAppear {
            // 現在の背景色のHexコードを選択状態に反映
//            selectedColor = Color(hex: userSettingsViewModel.settings.backgroundColor)
            if let category = closestColorCategory(to: selectedColor) {
                filteredImageNames = predefinedBackgroundImageNames.filter { $0.hasPrefix(category.name) }
            } else {
                filteredImageNames = predefinedBackgroundImageNames
            }
        }
        .sheet(isPresented: $isColorSheetPresented) {
            VStack(spacing: 20) {
                Text("色を選択")
                    .font(.headline)
                    .padding(.top)
                
                HStack(spacing: 15) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                        ForEach(colorCategories) { category in
                            Button(action: {
                                withAnimation {
                                    if selectedCategory?.name == category.name {
                                        // 既に選択されている場合は選択解除
                                        selectedCategory = nil
                                        filteredImageNames = predefinedBackgroundImageNames
                                    } else {
                                        // 新しく選択
                                        selectedCategory = category
                                        filteredImageNames = predefinedBackgroundImageNames.filter { $0.hasPrefix(category.name) }
                                    }
                                    
                                    // 背景画像をクリア
                                    userSettingsViewModel.clearBackgroundImage()
                                    
                                    // 背景色をデフォルトに戻す
                                    userSettingsViewModel.updateBackgroundColor(Color(hex: "#FFFFFF"))
                                    
                                    // シートを閉じる
                                    isColorSheetPresented = false
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(category.color)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedCategory?.name == category.name ? Color.black : Color.clear, lineWidth: 3)
                                        )
                                    
                                    if selectedCategory?.name == category.name {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .bold))
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // キャンセルボタン
                Button(action: {
                    isColorSheetPresented = false
                }) {
                    Text("キャンセル")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
    }
    
    func closestColorCategory(to color: Color) -> ColorCategory? {
        guard let selectedRGB = color.getRGB() else { return nil }
        
        var closestCategory: ColorCategory?
        var smallestDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        
        for category in colorCategories {
            guard let categoryRGB = category.color.getRGB() else { continue }
            
            let distance = sqrt(pow(selectedRGB.red - categoryRGB.red, 2) +
                                pow(selectedRGB.green - categoryRGB.green, 2) +
                                pow(selectedRGB.blue - categoryRGB.blue, 2))
            
            if distance < smallestDistance {
                smallestDistance = distance
                closestCategory = category
            }
        }
        
        return closestCategory
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView(userSettingsViewModel: UserSettingsViewModel(userID: "mockUserID123"))
    }
}
