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
    @State private var preFlag: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var userPreFlag: Int = 0
    @ObservedObject var authManager: AuthManager

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
        ColorCategory(name: "白", color: Color(hex: "#FFFFFF")),    // White
        ColorCategory(name: "黒", color: Color(hex: "#000000")),    // Black
        ColorCategory(name: "灰", color: Color(hex: "#808080")),    // Gray
        ColorCategory(name: "赤", color: Color(hex: "#FF0000")),    // Red
        ColorCategory(name: "橙", color: Color(hex: "#FFA500")),    // Orange
        ColorCategory(name: "黄", color: Color(hex: "#FFFF00")),    // Yellow
        ColorCategory(name: "薄緑", color: Color(hex: "#ADFF2F")),  // YellowGreen
        ColorCategory(name: "緑", color: Color(hex: "#008000")),    // Green
        ColorCategory(name: "水", color: Color(hex: "#00BFFF")),    // DeepSkyBlue
        ColorCategory(name: "青", color: Color(hex: "#0000FF")),    // Blue
        ColorCategory(name: "紫", color: Color(hex: "#800080")),    // Purple
        ColorCategory(name: "桃", color: Color(hex: "#FF66C4")),    // Peach
    ]
        
    var body: some View {
        VStack{

        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    generateHapticFeedback()
                    isColorSheetPresented = true
                }) {
                    HStack {
                        Image(systemName: "paintpalette")
                            .padding(.trailing, -5)
                        Text("色で探す")
                    }
                    .padding(5)
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
                    generateHapticFeedback()
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
            .padding(.horizontal)
            .padding(.top)
             ScrollView{
                    // 事前定義された背景画像のグリッド
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        
                        Button(action: {
                            generateHapticFeedback()
                            withAnimation {
                                userSettingsViewModel.clearBackgroundImage()
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(UIColor.secondarySystemBackground))
                                    .frame(height: 223)
                                
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
                                generateHapticFeedback()
                                if let number = extractNumber(from: imageName), (6...10).contains(number) {
                                    if authManager.userPreFlag == 0 {
                                        preFlag = true
                                    } else {
                                        withAnimation {
                                            userSettingsViewModel.updateBackgroundImage(named: imageName)
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        userSettingsViewModel.updateBackgroundImage(named: imageName)
                                    }
                                }
                            }) {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .cornerRadius(10)
                                        .clipped()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(userSettingsViewModel.backgroundImageName == imageName ? Color.black : Color.clear, lineWidth: 4)
                                        )
                                    if let number = extractNumber(from: imageName), (6...10).contains(number) {
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 20))
                                            .padding(5)
                                            .background(Color.black.opacity(0.7))
                                            .cornerRadius(10)
                                            .padding(10)
                                            .opacity(authManager.userPreFlag == 0 ? 1 : 0)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()  // 画面を閉じて戻る
            }) {
                Text("戻る")
                    .frame(maxWidth:.infinity)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
            }.padding()
        }
        .fullScreenCover(isPresented: $preFlag) {
            PreView(changeTitle: .constant(2))
        }
        .foregroundColor(Color("fontGray"))
        .background(Color("backgroundColor"))
        .onAppear {
            filteredImageNames = predefinedBackgroundImageNames
            authManager.fetchPreFlag{}
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                userPreFlag = authManager.userPreFlag
            }
        }
        .sheet(isPresented: $isColorSheetPresented) {
            VStack(spacing: 10) {
                Text("色を選択")
                    .font(.headline)
                    .padding(.top)
                
                HStack(spacing: 15) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                        ForEach(colorCategories) { category in
                            Button(action: {
                                generateHapticFeedback()
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
                                                .stroke(category.name == "白" ? Color.black : Color.clear, lineWidth: 1)
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(selectedCategory?.name == category.name ? Color.black : Color.clear, lineWidth: 3)
                                        )
                                    
                                    if selectedCategory?.name == category.name {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(selectedCategory?.name ==  "白" || selectedCategory?.name ==  "黄" ? .black : .white)
                                            .font(.system(size: 20, weight: .bold))
                                    }
                                }
                            }
                        }
                    }
                }
                // キャンセルボタン
//                Button(action: {
//                    generateHapticFeedback()
//                    isColorSheetPresented = false
//                }) {
//                    Text("キャンセル")
//                        .foregroundColor(.red)
//                        .padding()
//                }
            }
            .padding()
            .padding(.bottom)
            .foregroundColor(Color("fontGray"))
            .background(Color("backgroundColor"))
            .presentationDetents([.large,
                                  .height(280),
                                  .fraction(isSmallDevice() ? 0.30 : 0.23)
            ])
        }
    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func extractNumber(from imageName: String) -> Int? {
        let digits = imageName.compactMap { $0.wholeNumberValue }
        let numberString = digits.map(String.init).joined()
        return Int(numberString)
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
        BackgroundImageView(userSettingsViewModel: UserSettingsViewModel(), authManager: AuthManager())
    }
}
