//
//  HeaderEditView.swift
//  todo
//
//  Created by Apple on 2025/01/27.
//

import SwiftUI

struct HeaderEditorView: View {
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var headerText: String = ""
    @State private var headerColor: Color = .white
    @State private var headerImageName: String? = nil
    @State private var isHeaderSheetPresented: Bool = false
    @State private var isColorSheetPresented: Bool = false
    @State private var selectedCategory: ColorCategory? = nil
    @State private var filteredImageNames: [String] = []
    @State private var selectedColor: Color = Color.white
    @State private var selectedColorHex: String = "#FFFFFF"
    @State private var headerTextColor: Color = .black // デフォルトを黒に設定
    @State private var selectedTextColorHex: String = "#000000" // 選択されたテキスト色のHexコード
    @State private var isInitializing: Bool = true

    // 12色のHexコード
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
    
    let predefinedBackgroundImageNames: [String] = [
        "ヘッダ白1","ヘッダ白2","ヘッダ白3","ヘッダ白4","ヘッダ白5","ヘッダ白6","ヘッダ白7","ヘッダ白8","ヘッダ白9","ヘッダ白10","ヘッダ白11",
        "ヘッダ紫1","ヘッダ紫2","ヘッダ紫3","ヘッダ紫4","ヘッダ紫5","ヘッダ紫6","ヘッダ紫7","ヘッダ紫8","ヘッダ紫9","ヘッダ紫10","ヘッダ紫11",
        "ヘッダ青1","ヘッダ青2","ヘッダ青3","ヘッダ青4","ヘッダ青5","ヘッダ青6","ヘッダ青7","ヘッダ青8","ヘッダ青9","ヘッダ青10","ヘッダ青11",
        "ヘッダ水1","ヘッダ水2","ヘッダ水3","ヘッダ水4","ヘッダ水5","ヘッダ水6","ヘッダ水7","ヘッダ水8","ヘッダ水9","ヘッダ水10","ヘッダ水11",
        "ヘッダ薄水1","ヘッダ薄水2","ヘッダ薄水3","ヘッダ薄水4","ヘッダ薄水5","ヘッダ薄水6","ヘッダ薄水7","ヘッダ薄水8","ヘッダ薄水9","ヘッダ薄水10","ヘッダ薄水11",
        "ヘッダ黄1","ヘッダ黄2","ヘッダ黄3","ヘッダ黄4","ヘッダ黄5","ヘッダ黄6","ヘッダ黄7","ヘッダ黄8","ヘッダ黄9","ヘッダ黄10","ヘッダ黄11",
        "ヘッダ薄緑1","ヘッダ薄緑2","ヘッダ薄緑3","ヘッダ薄緑4","ヘッダ薄緑5","ヘッダ薄緑6","ヘッダ薄緑7","ヘッダ薄緑8","ヘッダ薄緑9","ヘッダ薄緑10","ヘッダ薄緑11",
        "ヘッダ緑1","ヘッダ緑2","ヘッダ緑3","ヘッダ緑4","ヘッダ緑5","ヘッダ緑6","ヘッダ緑7","ヘッダ緑8","ヘッダ緑9","ヘッダ緑10","ヘッダ緑11",
        "ヘッダ赤1","ヘッダ赤2","ヘッダ赤3","ヘッダ赤4","ヘッダ赤5","ヘッダ赤6","ヘッダ赤7","ヘッダ赤8","ヘッダ赤9","ヘッダ赤10","ヘッダ赤11",
        "ヘッダ橙1","ヘッダ橙2","ヘッダ橙3","ヘッダ橙4","ヘッダ橙5","ヘッダ橙6","ヘッダ橙7","ヘッダ橙8","ヘッダ橙9","ヘッダ橙10","ヘッダ橙11",
        "ヘッダ桃1","ヘッダ桃2","ヘッダ桃3","ヘッダ桃4","ヘッダ桃5","ヘッダ桃6","ヘッダ桃7","ヘッダ桃8","ヘッダ桃9","ヘッダ桃10","ヘッダ桃11",
        "ヘッダ黒1","ヘッダ黒2","ヘッダ黒3","ヘッダ黒4","ヘッダ黒5","ヘッダ黒6","ヘッダ黒7","ヘッダ黒8","ヘッダ黒9","ヘッダ黒10","ヘッダ黒11",
        "ヘッダ灰1","ヘッダ灰2","ヘッダ灰3","ヘッダ灰4","ヘッダ灰5","ヘッダ灰6","ヘッダ灰7","ヘッダ灰8","ヘッダ灰9","ヘッダ灰10","ヘッダ灰11"
    ]
    
    let colorCategories: [ColorCategory] = [
        ColorCategory(name: "ヘッダ黄", color: Color(hex: "#FFFF00")),    // Yellow
        ColorCategory(name: "ヘッダ薄緑", color: Color(hex: "#ADFF2F")),  // YellowGreen
        ColorCategory(name: "ヘッダ灰", color: Color(hex: "#808080")),    // Gray
        ColorCategory(name: "ヘッダ水", color: Color(hex: "#00BFFF")),    // DeepSkyBlue
        ColorCategory(name: "ヘッダ薄水", color: Color(hex: "#87CEFA")),  // LightSkyBlue
        ColorCategory(name: "ヘッダ青", color: Color(hex: "#0000FF")),    // Blue
        ColorCategory(name: "ヘッダ緑", color: Color(hex: "#008000")),    // Green
        
        // 追加する色カテゴリ
        ColorCategory(name: "ヘッダ紫", color: Color(hex: "#800080")),    // Purple
        ColorCategory(name: "ヘッダ赤", color: Color(hex: "#FF0000")),    // Red
        ColorCategory(name: "ヘッダ橙", color: Color(hex: "#FFA500")),    // Orange
        ColorCategory(name: "ヘッダ桃", color: Color(hex: "#FFDAB9")),    // Peach
        ColorCategory(name: "ヘッダ黒", color: Color(hex: "#000000")),    // Black
        ColorCategory(name: "ヘッダ白", color: Color(hex: "#FFFFFF")),    // White
    ]
    
    var body: some View {
        VStack(spacing: 20){
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("ヘッダーテキスト")
                        .font(.headline)
                    Spacer()
                }
                TextField("ヘッダーのテキストを入力", text: $headerText)
                    .border(Color.clear, width: 0)
                    .font(.system(size: 20))
                    .cornerRadius(8)
                    .onChange(of: headerText) { newValue in
                        if isInitializing { return }
                        userSettingsViewModel.updateHeaderText(newValue)
                    }
                Divider()
            }
            .padding(.horizontal)
            
            // ヘッダーテキスト色の編集
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("ヘッダーの文字色")
                        .font(.headline)
                    Spacer()
                }
                ColorPicker("文字色を選択", selection: $headerTextColor)
                    .padding(.trailing, 20)
                    .onChange(of: headerTextColor) { newColor in
                        if isInitializing { return }
                        if userSettingsViewModel.headerImageName != nil {
                            userSettingsViewModel.clearHeaderImage()
                        }
                        userSettingsViewModel.updateHeaderTextColor(newColor)
                        
                        // 選択された色のHexコードを更新
                        if let hex = newColor.toHex() {
                            selectedTextColorHex = hex
                        }
                    }
            }
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("文字色プリセットから選択")
                        .font(.headline)
                    Spacer()
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                    ForEach(predefinedColorHexes, id: \.self) { hex in
                        ColorButton(
                            hex: hex,
                            selectedHex: selectedTextColorHex
                        ) {
                            if isInitializing { return }
                            // まずヘッダーテキスト色をクリア（必要に応じて）
                            // userSettingsViewModel.clearHeaderTextColor() // 必要なら実装
                            
                            // その後、ヘッダーテキスト色を更新
                            selectedTextColorHex = hex
                            let selectedTextColor = Color(hex: hex)
                            headerTextColor = selectedTextColor
                            userSettingsViewModel.updateHeaderTextColor(selectedTextColor)
                        }
                    }
                }
                .padding(.horizontal)
            }
            //            VStack(alignment: .leading, spacing: 10) {
            //                HStack {
            //                    Spacer()
            //                    Text("ヘッダーの色")
            //                        .font(.headline)
            //                    Spacer()
            //                }
            //                ColorPicker("色を選択", selection: $headerColor)
            //                    .padding(.trailing, 20)
            //                    .onChange(of: headerColor) { newColor in
            //                        if isInitializing { return }
            //                        if userSettingsViewModel.headerImageName != nil {
            //                            userSettingsViewModel.clearHeaderImage()
            //                        }
            //                        userSettingsViewModel.updateHeaderColor(newColor)
            //
            //                        // 選択された色のHexコードを更新
            //                        if let hex = newColor.toHex() {
            //                            selectedColorHex = hex
            //                        }
            //                    }
            //            }
            //            .padding(.horizontal)
            
//                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
//                    ForEach(predefinedColorHexes, id: \.self) { hex in
//                        ColorButton(
//                            hex: hex,
//                            selectedHex: selectedColorHex
//                        ) {
//                            // まずヘッダー画像をクリア
//                            if userSettingsViewModel.headerImageName != nil {
//                                userSettingsViewModel.clearHeaderImage()
//                            }
//
//                            // その後、ヘッダー色を更新
//                            selectedColorHex = hex
//                            let selectedColor = Color(hex: hex)
//                            headerColor = selectedColor
//                            userSettingsViewModel.updateHeaderColor(selectedColor)
//                        }
//                    }
//                }
//                .padding(.horizontal)
            
            HStack {
                Button(action: {
                    isHeaderSheetPresented = true
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
                Text("ヘッダーを選択")
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
            .padding(.bottom, -10)
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                    
                    Button(action: {
                        withAnimation {
                            userSettingsViewModel.clearHeaderImage()
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.secondarySystemBackground))
                                .frame(height: 40)
                            
                            VStack {
                                Text("指定無し")
                                    .foregroundColor(.black)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    }
                    ForEach(filteredImageNames, id: \.self) { imageName in
                        HStack {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                                .onTapGesture {
                                    headerImageName = imageName
                                    if let imageName = headerImageName {
                                        userSettingsViewModel.updateHeaderImage(named: imageName)
                                    } else {
                                        userSettingsViewModel.clearHeaderImage()
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(headerImageName == imageName ? Color.blue : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
//            .navigationBarTitle("ヘッダー編集", displayMode: .inline)
//            .navigationBarItems(trailing: Button("完了") {
//                userSettingsViewModel.updateHeaderText(headerText)
//                userSettingsViewModel.updateHeaderColor(headerColor)
//                if let imageName = headerImageName {
//                    userSettingsViewModel.updateHeaderImage(named: imageName)
//                } else {
//                    userSettingsViewModel.clearHeaderImage()
//                }
//                presentationMode.wrappedValue.dismiss()
//            })
            .onAppear {
                self.headerText = userSettingsViewModel.headerText
                self.headerColor = userSettingsViewModel.headerColor
                self.headerTextColor = userSettingsViewModel.headerTextColor
                self.headerImageName = userSettingsViewModel.headerImageName
                        // 現在の背景色のHexコードを選択状態に反映
            //            selectedColor = Color(hex: userSettingsViewModel.settings.backgroundColor)
                        if let category = closestColorCategory(to: selectedColor) {
                            filteredImageNames = predefinedBackgroundImageNames.filter { $0.hasPrefix(category.name) }
                        } else {
                            filteredImageNames = predefinedBackgroundImageNames
                        }
                DispatchQueue.main.async {
                    isInitializing = false
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

#Preview {
    HeaderEditorView(userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!))
}
