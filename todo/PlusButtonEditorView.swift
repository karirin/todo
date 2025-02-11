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
    @State private var buttonRect: CGRect = .zero
    @State private var bubbleHeight: CGFloat = 0.0
    @State private var buttonRect2: CGRect = .zero
    @State private var bubbleHeight2: CGFloat = 0.0
    @State private var buttonRect3: CGRect = .zero
    @State private var bubbleHeight3: CGFloat = 0.0
    @State private var buttonRect4: CGRect = .zero
    @State private var bubbleHeight4: CGFloat = 0.0
    
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
    @State private var showCheckmark: Bool = false
    @Binding var tutorialNum: Int
    
    var body: some View {
        ZStack{
        VStack(spacing: 20) {
            
            // プラスボタンの画像選択セクション
            VStack(alignment: .leading, spacing: 10) {
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
                        .background(GeometryReader { geometry in
                            Color.clear.preference(key: ViewPositionKey4.self, value: [geometry.frame(in: .global)])
                        })
                    }
                }
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        // 画像無しオプション
                        Button(action: {
                            generateHapticFeedback()
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
                                if tutorialNum == 8 {
                                    tutorialNum = 9
                                }
                                generateHapticFeedback()
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
                            .background(
                                ZStack {
                                    // プラスボタン紫6 だけ GeometryReader を付与
                                    if imageName == "プラスボタン紫6" {
                                        GeometryReader { geometry in
                                            Color.clear
                                                .preference(key: ViewPositionKey5.self, value: [geometry.frame(in: .global)])
                                        }
                                    } else {
                                        Color.clear
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: ViewPositionKey3.self, value: [geometry.frame(in: .global)])
                })
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
                                .background(GeometryReader { geometry in
                                    Color.clear.preference(key: ViewPositionKey6.self, value: [geometry.frame(in: .global)])
                                })
        }
        .padding()
            if tutorialNum == 5 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: buttonRect.width, height: buttonRect.height)
                                .position(x: buttonRect.midX, y: isSmallDevice() ? buttonRect.midY - 40 : buttonRect.midY - 70)
                                .blendMode(.destinationOut)
                        )
                        .ignoresSafeArea()
                        .compositingGroup()
                        .background(.clear)
                        .onTapGesture {
                            generateHapticFeedback()
                            tutorialNum = 6
                        }
                }
                VStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                        Text("自分の好みのボタンを選択することができます")
                            .font(.callout)
                            .padding(5)
                            .font(.system(size: 24.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                        }
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 6
                        }) {
                        HStack {
                            Text("次へ")
                            Image(systemName: "chevron.forward.circle")
                        }
                        .padding(5)
                        .font(.system(size: 20.0))
                        .padding(.all, 8.0)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 16)
                        .foregroundColor(Color.black)
                        .shadow(radius: 10)
                        }
                    }
                    .background(GeometryReader { geometry in
                        Path { _ in
                            DispatchQueue.main.async {
                                self.bubbleHeight = geometry.size.height
                            }
                        }
                    })
                    Spacer()
                        .frame(height: buttonRect.minY - bubbleHeight + 150)
                }
                .ignoresSafeArea()
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 0
                        }) {
                            HStack {
                                Image(systemName: "chevron.left.2")
                                Text("スキップ")
                            }
                            .padding(5)
                            .font(.system(size: 20.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            if tutorialNum == 6 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: buttonRect2.width, height: buttonRect2.height)
                                .position(x: buttonRect2.midX, y: isSmallDevice() ? buttonRect2.midY - 40 : buttonRect2.midY - 70)
                                .blendMode(.destinationOut)
                        )
                        .ignoresSafeArea()
                        .compositingGroup()
                        .background(.clear)
                        .onTapGesture {
                            generateHapticFeedback()
                            tutorialNum = 7
                        }
                }
                VStack {
                    Spacer()
                        .frame(height: isSmallDevice() ? buttonRect2.minY - bubbleHeight2 + 130 : buttonRect2.minY - bubbleHeight2 + 100)
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                            Spacer()
                        Text("「色で探す」ボタンで絞り込み検索することもできます")
                            .font(.callout)
                            .padding(5)
                            .font(.system(size: 24.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 16)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                        }
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 7
                        }) {
                        HStack {
                            Text("次へ")
                            Image(systemName: "chevron.forward.circle")
                        }
                        .padding(5)
                        .font(.system(size: 20.0))
                        .padding(.all, 8.0)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 16)
                        .foregroundColor(Color.black)
                        .shadow(radius: 10)
                        }
                    }
                    .background(GeometryReader { geometry in
                        Path { _ in
                            DispatchQueue.main.async {
                                self.bubbleHeight2 = geometry.size.height
                            }
                        }
                    })
                    Spacer()
                }
                .ignoresSafeArea()
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 0
                        }) {
                            HStack {
                                Image(systemName: "chevron.left.2")
                                Text("スキップ")
                            }
                            .padding(5)
                            .font(.system(size: 20.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            if tutorialNum == 7 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: buttonRect3.width, height: buttonRect3.height)
                                .position(x: buttonRect3.midX, y: isSmallDevice() ? buttonRect3.midY - 40 :  buttonRect3.midY - 70)
                                .blendMode(.destinationOut)
                        )
                        .ignoresSafeArea()
                        .compositingGroup()
                        .background(.clear)
                        .onTapGesture {
                            generateHapticFeedback()
                            tutorialNum = 8
                        }
                }
                VStack {
                    Spacer()
                       // .frame(height: buttonRect3.minY - bubbleHeight3 )
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                            Spacer()
                        Text("試しにこのボタンを選択してみましょう")
                            .font(.callout)
                            .padding(5)
                            .font(.system(size: 24.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 16)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                        }
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 8
                        }) {
                        HStack {
                            Text("次へ")
                            Image(systemName: "chevron.forward.circle")
                        }
                        .padding(5)
                        .font(.system(size: 20.0))
                        .padding(.all, 8.0)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 16)
                        .foregroundColor(Color.black)
                        .shadow(radius: 10)
                        }
                    }
                    .padding(.bottom, isSmallDevice() ? 0 : 150)
                    .background(GeometryReader { geometry in
                        Path { _ in
                            DispatchQueue.main.async {
                                self.bubbleHeight3 = geometry.size.height
                            }
                        }
                    })
                    Spacer()
                }
                .ignoresSafeArea()
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 0
                        }) {
                            HStack {
                                Image(systemName: "chevron.left.2")
                                Text("スキップ")
                            }
                            .padding(5)
                            .font(.system(size: 20.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            if tutorialNum == 9 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .padding(-5)
                                .frame(width: buttonRect4.width, height: buttonRect4.height)
                                .position(x: buttonRect4.midX, y: isSmallDevice() ? buttonRect4.midY - 40 :  buttonRect4.midY - 70)
                                .blendMode(.destinationOut)
                        )
                        .ignoresSafeArea()
                        .compositingGroup()
                        .background(.clear)
                        .onTapGesture {
                            generateHapticFeedback()
                            tutorialNum = 10
                        }
                }
                VStack {
                    Spacer()
                        .frame(height: isSmallDevice() ? buttonRect4.minY - bubbleHeight4 - 60 : buttonRect4.minY - bubbleHeight4 - 90)
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                            Spacer()
                        Text("選択が完了したら「戻る」ボタンをクリックします")
                            .font(.callout)
                            .padding(5)
                            .font(.system(size: 24.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 16)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                        }
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 10
                        }) {
                        HStack {
                            Text("次へ")
                            Image(systemName: "chevron.forward.circle")
                        }
                        .padding(5)
                        .font(.system(size: 20.0))
                        .padding(.all, 8.0)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 16)
                        .foregroundColor(Color.black)
                        .shadow(radius: 10)
                        }
                    }
                    .background(GeometryReader { geometry in
                        Path { _ in
                            DispatchQueue.main.async {
                                self.bubbleHeight4 = geometry.size.height
                            }
                        }
                    })
                    Spacer()
                }
                .ignoresSafeArea()
                VStack{
                    HStack{
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 0
                        }) {
                            HStack {
                                Image(systemName: "chevron.left.2")
                                Text("スキップ")
                            }
                            .padding(5)
                            .font(.system(size: 20.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                        }
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
            }
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
                                        filteredImageNames = predefinedPlusButtonImageNames
                                        print("\(category.name) の選択を解除")
                                    } else {
                                        // 新しく選択
                                        selectedCategory = category
                                        filteredImageNames = predefinedPlusButtonImageNames.filter { $0.hasPrefix(category.name) }
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
        
        .onPreferenceChange(ViewPositionKey3.self) { positions in
            self.buttonRect = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey4.self) { positions in
            self.buttonRect2 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey5.self) { positions in
            self.buttonRect3 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey6.self) { positions in
            self.buttonRect4 = positions.first ?? .zero
        }
        .background(Color("backgroundColor"))
        .onAppear {
                selectedColor =  userSettingsViewModel.plusButtonColor
                selectedImageName = userSettingsViewModel.plusButtonImageName
                filteredImageNames = predefinedPlusButtonImageNames
        }
    }
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct PlusButtonEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PlusButtonEditorView(userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!), tutorialNum: .constant(9))
    }
}
