//
//  PostListEditorView.swift
//  todo
//
//  Created by Apple on 2025/01/28.
//

import SwiftUI

struct PostListEditorView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @State private var selectedColor: Color = Color.white
    @Environment(\.presentationMode) var presentationMode
    
    let predefinedBackgroundImageNames: [String] = [
        "投稿一覧紫1", "投稿一覧紫2", "投稿一覧紫3", "投稿一覧紫4", "投稿一覧紫5", "投稿一覧紫6", "投稿一覧紫7", "投稿一覧紫8", "投稿一覧紫9", "投稿一覧紫10","投稿一覧紫11",
        "投稿一覧青1", "投稿一覧青2", "投稿一覧青3", "投稿一覧青4", "投稿一覧青5", "投稿一覧青6", "投稿一覧青7", "投稿一覧青8", "投稿一覧青9", "投稿一覧青10", "投稿一覧青11",
        "投稿一覧水1", "投稿一覧水2", "投稿一覧水3", "投稿一覧水4", "投稿一覧水5", "投稿一覧水6", "投稿一覧水7", "投稿一覧水8", "投稿一覧水9", "投稿一覧水10","投稿一覧水11",
        "投稿一覧薄水1", "投稿一覧薄水2", "投稿一覧薄水3", "投稿一覧薄水4", "投稿一覧薄水5", "投稿一覧薄水6", "投稿一覧薄水7", "投稿一覧薄水8", "投稿一覧薄水9", "投稿一覧薄水10","投稿一覧薄水11",
        "投稿一覧黄1", "投稿一覧黄2", "投稿一覧黄3", "投稿一覧黄4", "投稿一覧黄5", "投稿一覧黄6", "投稿一覧黄7", "投稿一覧黄8", "投稿一覧黄9", "投稿一覧黄10","投稿一覧黄11",
        "投稿一覧薄緑1", "投稿一覧薄緑2", "投稿一覧薄緑3", "投稿一覧薄緑4", "投稿一覧薄緑5", "投稿一覧薄緑6", "投稿一覧薄緑7", "投稿一覧薄緑8", "投稿一覧薄緑9", "投稿一覧薄緑10","投稿一覧薄緑11",
        "投稿一覧緑1", "投稿一覧緑2", "投稿一覧緑3", "投稿一覧緑4", "投稿一覧緑5", "投稿一覧緑6", "投稿一覧緑7", "投稿一覧緑8", "投稿一覧緑9", "投稿一覧緑10","投稿一覧緑11",
        "投稿一覧赤1", "投稿一覧赤2", "投稿一覧赤3", "投稿一覧赤4", "投稿一覧赤5", "投稿一覧赤6", "投稿一覧赤7", "投稿一覧赤8", "投稿一覧赤9", "投稿一覧赤10","投稿一覧赤11",
        "投稿一覧橙1", "投稿一覧橙2", "投稿一覧橙3", "投稿一覧橙4", "投稿一覧橙5", "投稿一覧橙6", "投稿一覧橙7", "投稿一覧橙8", "投稿一覧橙9", "投稿一覧橙10","投稿一覧橙11",
        "投稿一覧桃1", "投稿一覧桃2", "投稿一覧桃3", "投稿一覧桃4", "投稿一覧桃5", "投稿一覧桃6", "投稿一覧桃7", "投稿一覧桃8", "投稿一覧桃9", "投稿一覧桃10","投稿一覧桃11",
        "投稿一覧黒1", "投稿一覧黒2", "投稿一覧黒3", "投稿一覧黒4", "投稿一覧黒5", "投稿一覧黒6", "投稿一覧黒7", "投稿一覧黒8", "投稿一覧黒9", "投稿一覧黒10","投稿一覧黒11",
        "投稿一覧灰1", "投稿一覧灰2", "投稿一覧灰3", "投稿一覧灰4", "投稿一覧灰5", "投稿一覧灰6", "投稿一覧灰7", "投稿一覧灰8", "投稿一覧灰9", "投稿一覧灰10","投稿一覧灰11",
        "投稿一覧白1", "投稿一覧白2", "投稿一覧白3", "投稿一覧白4", "投稿一覧白5", "投稿一覧白6", "投稿一覧白7", "投稿一覧白8", "投稿一覧白9", "投稿一覧白10","投稿一覧白11"
    ]
    
    // 色選択用のHexコード
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
    
    // 色カテゴリ
    let colorCategories: [ColorCategory] = [
        ColorCategory(name: "黄", color: Color(hex: "#FFFF00")),    // Yellow
        ColorCategory(name: "薄緑", color: Color(hex: "#ADFF2F")),  // YellowGreen
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
    
    // 選択された色のHexコード
    @State private var selectedColorHex: String = "#FFFFFF"
    
    // 並び替え機能の有効化フラグ
    @State private var isReorderEnabled: Bool = true
    
    // フィルタリングされた画像名
    @State private var filteredImageNames: [String] = []
    
    // 選択された色カテゴリ
    @State private var selectedCategory: ColorCategory? = nil
    
    // カラーカテゴリ選択シートの表示フラグ
    @State private var isColorSheetPresented: Bool = false
    
    var body: some View {
//        NavigationView {
//            ScrollView {
                VStack(spacing: 20) {
//                    // 投稿一覧の色変更セクション
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("投稿一覧の色")
//                            .font(.headline)
//                        ColorPicker("色を選択", selection: Binding(
//                            get: {
//                                userSettingsViewModel.postListColor
//                            },
//                            set: { newColor in
//                                userSettingsViewModel.updatePostListColor(newColor)
//                                if let hex = newColor.toHex() {
//                                    selectedColorHex = hex
//                                }
//                            }
//                        ))
//                    }
//                    .padding(.horizontal)
                    
                    // 投稿一覧の色プリセットセクション
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("プリセットカラーから選択")
//                            .font(.headline)
//                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
//                            ForEach(predefinedColorHexes, id: \.self) { hex in
//                                ColorButton(
//                                    hex: hex,
//                                    selectedHex: selectedColorHex
//                                ) {
//                                    // 色を選択
//                                    selectedColorHex = hex
//                                    let selectedColor = Color(hex: hex)
//                                    userSettingsViewModel.updatePostListColor(selectedColor)
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
                    
                    // 投稿一覧の背景画像セクション
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {Button(action: {
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
                            Text("投稿の背景画像")
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
//                        .padding(.horizontal)
                        
                        // 背景画像のグリッド
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                            
                            // 背景無しボタン
                            Button(action: {
                                withAnimation {
                                    userSettingsViewModel.clearPostListImage()
                                    userSettingsViewModel.updatePostListColor(Color(hex: "#FFFFFF"))
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                        .frame(height: 40)
                                    
                                    VStack {
                                        Text("背景無し")
                                            .foregroundColor(.black)
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(userSettingsViewModel.postListImageName == nil ? Color.black : Color.clear, lineWidth: 2)
                                )
                            }
                            
                            // フィルタリングされた背景画像ボタン
                            ForEach(filteredImageNames, id: \.self) { imageName in
                                Button(action: {
                                    withAnimation {
                                        userSettingsViewModel.updatePostListImage(named: imageName)
                                        userSettingsViewModel.updatePostListColor(Color(hex: "#FFFFFF"))
                                    }
                                }) {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .cornerRadius(10)
                                        .clipped()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(userSettingsViewModel.postListImageName == imageName ? Color.black : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .onAppear{
                    if let category = closestColorCategory(to: userSettingsViewModel.postListColor) {
                        print("predefinedBackgroundImageNames   :\(userSettingsViewModel.postListColor)")
                        filteredImageNames = predefinedBackgroundImageNames.filter { $0.hasPrefix("投稿一覧" + category.name) }
                        print("filteredImageNames1   :\(filteredImageNames)")
                    } else {
                        filteredImageNames = predefinedBackgroundImageNames
                    }
                }
                .padding()
//            }
//            .navigationBarTitle("投稿一覧編集", displayMode: .inline)
//            .navigationBarItems(trailing: Button("完了") {
//                presentationMode.wrappedValue.dismiss()
//            })
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
                                            filteredImageNames = predefinedBackgroundImageNames.filter { $0.hasPrefix("投稿一覧" + category.name) }
                                        }
                                        
                                        // 背景画像をクリア
                                        userSettingsViewModel.clearPostListImage()
                                        
                                        // 投稿一覧の色をデフォルトに戻す
                                        userSettingsViewModel.updatePostListColor(Color(hex: "#FFFFFF"))
                                        
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
                                .buttonStyle(PlainButtonStyle())
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
    
    
    /// 選択された色に最も近い色カテゴリを取得
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

struct PostListEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PostListEditorView(
            todoViewModel: TodoViewModel(userID: "mockUserID"),
            userSettingsViewModel: UserSettingsViewModel(userID: "mockUserID")
        )
    }
}
