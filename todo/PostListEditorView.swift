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
    @State private var selectedColor: String = "#000000"
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTextColor: Color = .black
    @State private var postListOpacityFlag: Bool = false
    @State private var isInitializing: Bool = true
    
    let predefinedColors: [String] = [
        "#FEFEFE", // White
        "#000000", // Black
        "#808080", // Gray
        "#FE0000", // Red
        "#FEA500", // Orange
        "#FEFE00", // Yellow
        "#008000", // Green
        "#0000FE", // Blue
        "#800080", // Purple
        "#A52A2A"  // Brown
    ]
    
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
    
    // 選択された色カテゴリ
    @State private var selectedCategory: ColorCategory? = nil
    
    // フィルタリングされた画像名
    @State private var filteredImageNames: [String] = []
    
    // カラーカテゴリ選択シートの表示フラグ
    @State private var isColorSheetPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("文字色を選択")
                .font(.headline)
                .padding(.top)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                ForEach(predefinedColors, id: \.self) { color in
                    Button(action: {
                        userSettingsViewModel.updateTodoTextColor(Color(hex:color))
                        generateHapticFeedback()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex:color))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(color.lowercased() == userSettingsViewModel.postListTextColor.toHex()!.lowercased() ? Color.black : Color.clear, lineWidth: 3)
                                )
                            
                            if color.lowercased() == userSettingsViewModel.postListTextColor.toHex()!.lowercased() {
                                Image(systemName: "checkmark")
                                    .foregroundColor(color == "#FEFEFE" || color == "#FEFE00" ? .black : .white)
                                    .font(.system(size: 20, weight: .bold))
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            Toggle("文字を見やすくする", isOn:
                Binding(
                    get: { userSettingsViewModel.postListOpacityFlag },
                    set: { newValue in
                        userSettingsViewModel.updatePostListOpacityFlag(newValue)
                    }
                )
            ).padding(.horizontal,20)
                // 投稿一覧の背景画像セクション
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        // 背景画像を色でフィルタリングするボタン
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
                        .opacity(0)
                        Spacer()
                        Text("投稿の背景画像")
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
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    ScrollView{
                    // 背景画像のグリッド
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        
                        // 背景無しボタン
                        Button(action: {
                            generateHapticFeedback()
                            withAnimation {
                                userSettingsViewModel.updatePostListImage(named: "投稿一覧白1")
                                print("背景無しを選択")
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
                                generateHapticFeedback()
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
                                            .stroke(userSettingsViewModel.postListImageName == imageName ? Color.black : Color.clear, lineWidth: 3)
                                    )
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
                    }.padding()
            }
        }
        .background(Color("backgroundColor"))
        .onAppear{
                // 投稿一覧色に基づいてフィルタリング
                if let category = closestColorCategory(to: userSettingsViewModel.postListColor) {
                    filteredImageNames = predefinedBackgroundImageNames
                } else {
                    filteredImageNames = predefinedBackgroundImageNames
                    print("色カテゴリが見つからなかったため、全ての画像を表示")
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
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(colorCategories) { category in
                            Button(action: {
                                generateHapticFeedback()
                                withAnimation {
                                    if selectedCategory?.name == category.name {
                                        // 既に選択されている場合は選択解除
                                        selectedCategory = nil
                                        filteredImageNames = predefinedBackgroundImageNames
                                        print("\(category.name) の選択を解除")
                                    } else {
                                        // 新しく選択
                                        selectedCategory = category
                                        filteredImageNames = predefinedBackgroundImageNames.filter { $0.hasPrefix("投稿一覧" + category.name) }
                                        print("\(category.name) を選択")
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
            }
            .padding()
            .presentationDetents([.large,
                                  .height(280),
                                  .fraction(isSmallDevice() ? 0.4 : 0.35)
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
            
            print("カテゴリ: \(category.name), 距離: \(distance)")
            
            if distance < smallestDistance {
                smallestDistance = distance
                closestCategory = category
            }
        }
        
        if let closest = closestCategory {
            print("最も近いカテゴリ: \(closest.name)")
        } else {
            print("最も近いカテゴリが見つかりませんでした。")
        }
        
        return closestCategory
    }
}

struct PostListEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PostListEditorView(
            todoViewModel: TodoViewModel(userID: AuthManager().currentUserId!),
            userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!)
        )
    }
}
