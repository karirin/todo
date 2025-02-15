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
    @State private var headerOpacityFlag: Bool = false
    @State private var preFlag: Bool = false
    @State private var isTextColorPickerExpanded: Bool = false
    @State private var userPreFlag: Int = 0
    @ObservedObject var authManager: AuthManager

    let predefinedColorHexes: [String] = [
        "#FEFEFE", // White
        "#000000", // Black
        "#808080", // Gray
        "#FE0000", // Red
        "#FFA500", // Orange
        "#FEFE00", // Yellow
        "#008000", // Green
        "#0000FE", // Blue
        "#800080", // Purple
        "#A52A2A"  // Brown
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
        ColorCategory(name: "ヘッダ白", color: Color(hex: "#FFFFFF")),    // White
        ColorCategory(name: "ヘッダ黒", color: Color(hex: "#000000")),    // Black
        ColorCategory(name: "ヘッダ灰", color: Color(hex: "#808080")),    // Gray
        ColorCategory(name: "ヘッダ赤", color: Color(hex: "#FF0000")),    // Red
        ColorCategory(name: "ヘッダ橙", color: Color(hex: "#FFA500")),    // Orange
        ColorCategory(name: "ヘッダ黄", color: Color(hex: "#FFFF00")),    // Yellow
        ColorCategory(name: "ヘッダ薄緑", color: Color(hex: "#ADFF2F")),  // YellowGreen
        ColorCategory(name: "ヘッダ緑", color: Color(hex: "#008000")),    // Green
        ColorCategory(name: "ヘッダ水", color: Color(hex: "#00BFFF")),    // DeepSkyBlue
        ColorCategory(name: "ヘッダ青", color: Color(hex: "#0000FF")),    // Blue
        ColorCategory(name: "ヘッダ紫", color: Color(hex: "#800080")),    // Purple
        ColorCategory(name: "ヘッダ桃", color: Color(hex: "#FF66C4")),    // Peach
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
                TextField("ヘッダーのテキストを入力", text: $userSettingsViewModel.headerText)
                    .border(Color.clear, width: 0)
                    .font(.system(size: 20))
                    .cornerRadius(8)
                    .onChange(of: userSettingsViewModel.headerText) { newValue in
                        if isInitializing { return }
                        userSettingsViewModel.updateHeaderText(newValue)
                    }
                Divider()
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Button(action: {
                    isTextColorPickerExpanded.toggle()
                    generateHapticFeedback()
                }) {
                    HStack{
                        Text("もっと見る")
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .opacity(0)
                        Spacer()
                        Text("文字色を選択")
                            .font(.headline)
                        Spacer()
                        Text("もっと見る")
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                    ForEach(predefinedColorHexes.prefix(isTextColorPickerExpanded ? 10 : 5), id: \.self) { hex in
                        ColorButton(
                            hex: hex,
                            selectedHex: userSettingsViewModel.headerTextColor.toHex()!
                        ) {
                            withAnimation {
                                if isInitializing { return }
                                generateHapticFeedback()
                                // その後、ヘッダーテキスト色を更新
//                                selectedHex = hex
                                selectedTextColorHex = hex
                                let selectedTextColor = Color(hex: hex)
                                headerTextColor = selectedTextColor
                                userSettingsViewModel.updateHeaderTextColor(selectedTextColor)
                            }
                        }
                        .onAppear{
                            
                            print("hex      :\(hex)")
                            print("userSettingsViewModel.headerTextColor.toHex()!   :\(userSettingsViewModel.headerTextColor.toHex()!)")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                print("hex      1:\(hex)")
                                print("userSettingsViewModel.headerTextColor.toHex()!   1:\(userSettingsViewModel.headerTextColor)")
                            }
                        }
                    }
                }
            }
            
            Toggle("文字を見やすくする", isOn: $userSettingsViewModel.headerOpacityFlag)
                .font(.headline)
                .padding(.horizontal)
                .onChange(of: userSettingsViewModel.headerOpacityFlag) { newValue in
                    if isInitializing { return }
                    userSettingsViewModel.updateHeaderOpacityFlag(newValue)
                }

            HStack {
                Button(action: {
                    generateHapticFeedback()
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
                    .padding(.horizontal,isSmallDevice() ? -10 : 0)
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
                        generateHapticFeedback()
                        withAnimation {
                            userSettingsViewModel.updateHeaderImage(named: "ヘッダ白1")
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
                            ZStack{
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        generateHapticFeedback()
                                        withAnimation {
                                            if let number = extractNumber(from: imageName), (6...11).contains(number) {
                                                if authManager.userPreFlag == 0 {
                                                    preFlag = true
                                                } else {
                                                    withAnimation {
                                                        headerImageName = imageName
                                                        if let imageName = headerImageName {
                                                            userSettingsViewModel.updateHeaderImage(named: imageName)
                                                        } else {
                                                            userSettingsViewModel.clearHeaderImage()
                                                        }
                                                    }
                                                }
                                            } else {
                                                withAnimation {
                                                    headerImageName = imageName
                                                    if let imageName = headerImageName {
                                                        userSettingsViewModel.updateHeaderImage(named: imageName)
                                                    } else {
                                                        userSettingsViewModel.clearHeaderImage()
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(userSettingsViewModel.headerImageName == imageName ? Color.black : Color.clear, lineWidth: 3)
                                    )
                                if let number = extractNumber(from: imageName), (6...11).contains(number) {
                                    HStack{
                                        Spacer()
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 16))
                                            .padding(5)
                                            .background(Color.black.opacity(0.7))
                                            .cornerRadius(10)
                                            .padding(.trailing, 10)
                                            .opacity(authManager.userPreFlag == 0 ? 1 : 0)
                                    }
                                }
                            }
                        }
                    }
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
            }
        }
        .padding()
        .foregroundColor(Color("fontGray"))
        .background(Color("backgroundColor"))
        .onAppear {
                self.headerText = userSettingsViewModel.headerText
                self.headerImageName = userSettingsViewModel.headerImageName
                self.headerOpacityFlag = userSettingsViewModel.headerOpacityFlag
                if let category = closestColorCategory(to: selectedColor) {
                    filteredImageNames = predefinedBackgroundImageNames
                } else {
                    filteredImageNames = predefinedBackgroundImageNames
                }
                authManager.fetchPreFlag{}
                DispatchQueue.main.async {
                    isInitializing = false
                }
            }
            .fullScreenCover(isPresented: $preFlag) {
                PreView(changeTitle: .constant(2))
            }
            .sheet(isPresented: $isColorSheetPresented) {
                VStack(spacing: 20) {
                    Text("色を選択")
                        .font(.headline)
                        .padding(.top)
                    
                    HStack(spacing: 15) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 20) {
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
                                                    .stroke(category.name == "ヘッダ白" ? Color.black : Color.clear, lineWidth: 1)
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedCategory?.name == category.name ? Color.black : Color.clear, lineWidth: 3)
                                            )
                                        
                                        if selectedCategory?.name == category.name {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(selectedCategory?.name ==  "ヘッダ白" || selectedCategory?.name ==  "ヘッダ黄" ? .black : .white)
                                                .font(.system(size: 20, weight: .bold))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom)
                .foregroundColor(Color("fontGray"))
                .background(Color("backgroundColor"))
                .presentationDetents([.large,
                                      .height(280),
                                      .fraction(isSmallDevice() ? 0.32 : 0.23)
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

#Preview {
    HeaderEditorView(userSettingsViewModel: UserSettingsViewModel(), authManager: AuthManager())
}
