//
//  PlusButtonEditorView.swift
//  todo
//
//  Created by Apple on 2025/01/29.
//

import SwiftUI

struct PlusButtonEditorView: View {
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedColor: Color = Color.black
    @State private var selectedImageName: String? = nil
    @State private var filteredImageNames: [String] = []
    @State private var isColorSheetPresented: Bool = false
    
    // 予めアセットに追加されている画像名を列挙
    let predefinedPlusButtonImageNames: [String] = [
        "プラスボタン紫1", "プラスボタン紫2", "プラスボタン紫3", "プラスボタン紫4", "プラスボタン紫5", "プラスボタン紫6", "プラスボタン紫7", "プラスボタン紫8", "プラスボタン紫9", "プラスボタン紫10",
        "プラスボタン青1", "プラスボタン青2", "プラスボタン青3", "プラスボタン青4", "プラスボタン青5", "プラスボタン青6", "プラスボタン青7", "プラスボタン青8", "プラスボタン青9", "プラスボタン青10",
        "プラスボタン水1", "プラスボタン水2", "プラスボタン水3", "プラスボタン水4", "プラスボタン水5", "プラスボタン水6", "プラスボタン水7", "プラスボタン水8", "プラスボタン水9", "プラスボタン水10",
        "プラスボタン薄水1", "プラスボタン薄水2", "プラスボタン薄水3", "プラスボタン薄水4", "プラスボタン薄水5", "プラスボタン薄水6", "プラスボタン薄水7", "プラスボタン薄水8", "プラスボタン薄水9", "プラスボタン薄水10",
        "プラスボタン黄1", "プラスボタン黄2", "プラスボタン黄3", "プラスボタン黄4", "プラスボタン黄5", "プラスボタン黄6", "プラスボタン黄7", "プラスボタン黄8", "プラスボタン黄9", "プラスボタン黄10",
        "プラスボタン薄緑1", "プラスボタン薄緑2", "プラスボタン薄緑3", "プラスボタン薄緑4", "プラスボタン薄緑5", "プラスボタン薄緑6", "プラスボタン薄緑7", "プラスボタン薄緑8", "プラスボタン薄緑9", "プラスボタン薄緑10",
        "プラスボタン緑1", "プラスボタン緑2", "プラスボタン緑3", "プラスボタン緑4", "プラスボタン緑5", "プラスボタン緑6", "プラスボタン緑7", "プラスボタン緑8", "プラスボタン緑9", "プラスボタン緑10",
        "プラスボタン赤1", "プラスボタン赤2", "プラスボタン赤3", "プラスボタン赤4", "プラスボタン赤5", "プラスボタン赤6", "プラスボタン赤7", "プラスボタン赤8", "プラスボタン赤9", "プラスボタン赤10",
        "プラスボタン橙1", "プラスボタン橙2", "プラスボタン橙3", "プラスボタン橙4", "プラスボタン橙5", "プラスボタン橙6", "プラスボタン橙7", "プラスボタン橙8", "プラスボタン橙9", "プラスボタン橙10",
        "プラスボタン桃1", "プラスボタン桃2", "プラスボタン桃3", "プラスボタン桃4", "プラスボタン桃5", "プラスボタン桃6", "プラスボタン桃7", "プラスボタン桃8", "プラスボタン桃9", "プラスボタン桃10",
        "プラスボタン黒1", "プラスボタン黒2", "プラスボタン黒3", "プラスボタン黒4", "プラスボタン黒5", "プラスボタン黒6", "プラスボタン黒7", "プラスボタン黒8", "プラスボタン黒9", "プラスボタン黒10",
        "プラスボタン灰1", "プラスボタン灰2", "プラスボタン灰3", "プラスボタン灰4", "プラスボタン灰5", "プラスボタン灰6", "プラスボタン灰7", "プラスボタン灰8", "プラスボタン灰9", "プラスボタン灰10",
        "プラスボタン白1", "プラスボタン白2", "プラスボタン白3", "プラスボタン白4", "プラスボタン白5", "プラスボタン白6", "プラスボタン白7", "プラスボタン白8", "プラスボタン白9", "プラスボタン白10"
    ]
    
    let colorCategories: [ColorCategory] = [
        ColorCategory(name: "プラスボタン黄", color: Color(hex: "#FFFF00")),    // Yellow
        ColorCategory(name: "プラスボタン薄緑", color: Color(hex: "#ADFF2F")),  // YellowGreen
        ColorCategory(name: "プラスボタン灰", color: Color(hex: "#808080")),    // Gray
        ColorCategory(name: "プラスボタン水", color: Color(hex: "#00BFFF")),    // DeepSkyBlue
        ColorCategory(name: "プラスボタン薄水", color: Color(hex: "#87CEFA")),  // LightSkyBlue
        ColorCategory(name: "プラスボタン青", color: Color(hex: "#0000FF")),    // Blue
        ColorCategory(name: "プラスボタン緑", color: Color(hex: "#008000")),    // Green
        
        // 追加する色カテゴリ
        ColorCategory(name: "プラスボタン紫", color: Color(hex: "#800080")),    // Purple
        ColorCategory(name: "プラスボタン赤", color: Color(hex: "#FF0000")),    // Red
        ColorCategory(name: "プラスボタン橙", color: Color(hex: "#FFA500")),    // Orange
        ColorCategory(name: "プラスボタン桃", color: Color(hex: "#FFDAB9")),    // Peach
        ColorCategory(name: "プラスボタン黒", color: Color(hex: "#000000")),    // Black
        ColorCategory(name: "プラスボタン白", color: Color(hex: "#FFFFFF")),    // White
    ]
    
    @State private var selectedCategory: ColorCategory? = nil
    
    // 定義済みのカラー配列（`predefinedColors` と `predefinedColorHexes` を統一）
    let predefinedColors: [Color] = [
        .white, .black, .gray, .red, .orange, .yellow, .green, .blue, .purple, .brown
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // カラー選択セクション
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("ボタンの色を選択")
                        .font(.headline)
                    Spacer()
                }
                HStack(spacing: 15) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(predefinedColors, id: \.self) { color in
                            Button(action: {
                                selectedColor = color
                                userSettingsViewModel.updatePlusButtonColor(color)
                                print("選択されたプラスボタン色: \(color.toHex() ?? "N/A")")
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 50, height: 50)
                                    
                                    if color == selectedColor {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .bold))
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // プラスボタンの画像選択セクション
            VStack(alignment: .leading, spacing: 10) {
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
                    }
                    .opacity(0) // 左側のボタンを非表示にするため
                    Spacer()
                    Text("ボタンを選択")
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
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        // 画像無しオプション
                        Button(action: {
                            withAnimation {
                                userSettingsViewModel.clearPlusButtonImage()
                                selectedImageName = nil
                                print("プラスボタン画像をクリア")
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(UIColor.secondarySystemBackground))
                                    .frame(width: 60, height: 60)
                                
                                VStack {
                                    Text("指定\n無し")
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        }
                        
                        // プリセット画像選択オプション
                        ForEach(filteredImageNames, id: \.self) { imageName in
                            Button(action: {
                                userSettingsViewModel.updatePlusButtonImage(named: imageName)
                                selectedImageName = imageName
                                print("選択されたプラスボタン画像: \(imageName)")
                            }) {
                                VStack {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .padding()
                                }
                                .background(selectedImageName == imageName ? Color.gray.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
        .padding()
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
                                        filteredImageNames = predefinedPlusButtonImageNames
                                        print("\(category.name) の選択を解除")
                                    } else {
                                        // 新しく選択
                                        selectedCategory = category
                                        filteredImageNames = predefinedPlusButtonImageNames.filter { $0.hasPrefix(category.name) }
                                        print("\(category.name) を選択")
                                    }
                                    
                                    // 画像をクリア
                                    userSettingsViewModel.clearPlusButtonImage()
                                    
                                    // 色をデフォルトに戻す（必要に応じて）
                                    userSettingsViewModel.updatePlusButtonColor(Color.black)
                                    
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
        .background(Color("backgroundColor"))
        .navigationBarTitle("プラスボタン編集", displayMode: .inline)
        .navigationBarItems(trailing: Button("完了") {
            presentationMode.wrappedValue.dismiss()
        })
        .onAppear {
            // 初期選択状態を設定
            selectedColor = userSettingsViewModel.plusButtonColor
            selectedImageName = userSettingsViewModel.plusButtonImageName
            // 初期表示で全ての画像を表示
            filteredImageNames = predefinedPlusButtonImageNames
            print("初期表示で全てのプラスボタン画像を表示")
        }
    }
}

struct PlusButtonEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PlusButtonEditorView(userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!))
    }
}
