//
//  PresetEditorView.swift
//  todo
//
//  Created by Apple on 2025/02/01.
//

import SwiftUI

struct PresetEditorView: View {
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var presetName: String = ""
    @State private var addFlag = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var showChangeAlert = false
    @State private var selectedPresetKey: String? = nil
    @State private var showDeleteAlert = false
    @State private var isSquarePreview: Bool = true
    @State private var isEditing: Bool = false
    @State private var tutorialNum: Int = 0
    @State private var buttonRect: CGRect = .zero
    @State private var bubbleHeight: CGFloat = 0.0
    @State private var buttonRect2: CGRect = .zero
    @State private var bubbleHeight2: CGFloat = 0.0
    @State private var buttonRect3: CGRect = .zero
    @State private var bubbleHeight3: CGFloat = 0.0
    @State private var buttonRect4: CGRect = .zero
    @State private var bubbleHeight4: CGFloat = 0.0
    @State private var buttonRect5: CGRect = .zero
    @State private var bubbleHeight5: CGFloat = 0.0
    @State private var buttonRect6: CGRect = .zero
    @State private var bubbleHeight6: CGFloat = 0.0
    @State private var buttonRect7: CGRect = .zero
    @State private var bubbleHeight7: CGFloat = 0.0
    @State private var buttonRect8: CGRect = .zero
    @State private var bubbleHeight8: CGFloat = 0.0
    
    var body: some View {
        ZStack {
        VStack {
            HStack {
                Button(action: {
                    generateHapticFeedback()
                    tutorialNum = 1
                }) {
                    Image(systemName: "questionmark.circle.fill" )
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                }
                .padding(.leading)
                Spacer()
                Text("カスタマイズ一覧")
                    .foregroundColor(userSettingsViewModel.headerTextColor)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .padding(.horizontal,5)
                    .background(Color("backgroundColor").opacity(userSettingsViewModel.headerOpacityFlag ? 0.6 : 0))
                    .cornerRadius(10)
                Spacer()
                Button(action: {
                    generateHapticFeedback()
                    isEditing.toggle()
                    if tutorialNum == 8 {
                        tutorialNum = 9
                    }
                }) {
                    Text(isEditing ? "完了" : "編集")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .background(GeometryReader { geometry in
                            Color.clear.preference(key: ViewPositionKey14.self, value: [geometry.frame(in: .global)])
                        })
                        .padding(.trailing, 10)
                }
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(
                    Group {
                        if let headerImageName = userSettingsViewModel.headerImageName,
                           let uiImage = UIImage(named: headerImageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .edgesIgnoringSafeArea(.all)
                        } else {
                            userSettingsViewModel.headerColor
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                )
            ZStack {
                VStack{
                    Text("現在のカスタマイズ")
                        .font(.headline)
                        .padding(.bottom, isSquarePreview ? 0 : -15)
                    VStack{
                        if let headerImageName = userSettingsViewModel.settings.header.headerImageName,
                           let uiHeaderImage = UIImage(named: headerImageName) {
                            Image(uiImage: uiHeaderImage)
                                .resizable()
                                .scaledToFill()
                                .padding(.horizontal, 1.5)
                                .frame(height: 20)
                            
                                .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                                .padding(.bottom, -30)
                                .padding(.top,  isSquarePreview ? 110 : 20)
                                .zIndex(1)
                        } else {
                            userSettingsViewModel.headerColor
                                .frame(height: isSquarePreview ? 100 : 20)
                                .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                                .padding(.bottom, -30)
                                .padding(.top, 20).zIndex(1)
                        }
                        ZStack{
                            if let bgImageName = userSettingsViewModel.settings.background.backgroundImageName,
                               let uiImage = UIImage(named: bgImageName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 210)
                                    .clipShape(RoundedCorner(radius: 10))
                            } else {
                                userSettingsViewModel.backgroundColor
                                    .frame(height: 210)
                                    .clipShape(RoundedCorner(radius: 10))
                            }
                            
                            if let bgImageName = userSettingsViewModel.settings.postList.postListImageName,
                               let uiBGImage = UIImage(named: bgImageName) {
                                VStack{
                                    Image(uiImage: uiBGImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                        .cornerRadius(4)
                                    Image(uiImage: uiBGImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                        .cornerRadius(4)
                                        .opacity(isSquarePreview ? 0 : 1)
                                    Spacer()
                                }.padding(10)
                                    .padding(.top,isSquarePreview ? 30 : 20)
                            } else {
                                VStack{
                                    userSettingsViewModel.postListColor
                                        .frame(height: 20)
                                    userSettingsViewModel.postListColor
                                        .frame(height: 20)
                                        .opacity(isSquarePreview ? 0 : 1)
                                    Spacer()
                                }.padding(10)
                                    .padding(.top,isSquarePreview ? 30 :  20)
                            }
                            
                            Spacer()
                            // 背景のプレビュー（背景画像があれば表示、なければ背景色）
                            if let bgImageName = userSettingsViewModel.settings.plusButton.plusButtonImageName,
                               let uiBGImage = UIImage(named: bgImageName) {
                                VStack{
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        Image(uiImage: uiBGImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 20)
                                            .padding(.top, isSquarePreview ? -105 : -20)
                                    }
                                    .padding(.bottom, 30)
                                    .padding(.trailing, 10)
                                }
                            } else {
                                VStack{
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        Image(systemName: "plus")
                                            .font(.system(size: 15))
                                            .padding(5)
                                            .background(userSettingsViewModel.plusButtonColor)
                                            .foregroundColor(Color.white)
                                            .clipShape(Circle())
                                            .padding(.top, isSquarePreview ? -100 : -20)
                                    }
                                    .padding(.bottom, 30)
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                    }
                    .frame(width: 100, height: isSquarePreview ? 100 : 250)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding(.bottom, isSquarePreview ? 20 : 0)
                }
            }
            ScrollView {
                HStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                        ForEach(Array(userSettingsViewModel.presets.keys).sorted(), id: \.self) { key in
                            if let preset = userSettingsViewModel.presets[key] {
                                Button(action: {
                                    generateHapticFeedback()
                                    selectedPresetKey = key
                                    showChangeAlert = true
                                }) {
                                    ZStack {
                                       VStack{
                                           if let headerImageName = preset.header.headerImageName ,
                                              let uiHeaderImage = UIImage(named: headerImageName) {
                                               Image(uiImage: uiHeaderImage)
                                                   .resizable()
                                                   .scaledToFill()
                                                   .padding(.horizontal, 1.5)
                                                   .frame(height: 20)
                                               
                                                   .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                                                   .padding(.bottom, -30)
                                                   .padding(.top,  isSquarePreview ? 110 : 20)
                                                   .zIndex(1)
                                           } else {
                                               userSettingsViewModel.headerColor
                                                   .frame(height: 20)
                                                   .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                                                   .padding(.bottom, -20).padding(.top,10).zIndex(1)
                                           }
                                           ZStack{
                                               if let bgImageName = preset.background.backgroundImageName,
                                                  let uiImage = UIImage(named: bgImageName) {
                                                   Image(uiImage: uiImage)
                                                       .resizable()
                                                       .scaledToFit()
                                                       .frame(height: 210)
                                                       .clipShape(RoundedCorner(radius: 10))
                                               } else {
                                                   userSettingsViewModel.backgroundColor
                                                       .frame(height: 210)
                                                   
                                                       .clipShape(RoundedCorner(radius: 10))
                                               }
                                               
                                               if let bgImageName = preset.postList.postListImageName,
                                                                                                 let uiPLImage = UIImage(named: bgImageName) {
                                                   VStack{
                                                       Image(uiImage: uiPLImage)
                                                           .resizable()
                                                           .scaledToFit()
                                                           .frame(height: 20)
                                                           .cornerRadius(4)
                                                       Image(uiImage: uiPLImage)
                                                           .resizable()
                                                           .scaledToFit()
                                                           .frame(height: 20)
                                                           .cornerRadius(4)
                                                           .opacity(isSquarePreview ? 0 : 1)
                                                       Spacer()
                                                   }.padding(10)
                                                       .padding(.top,isSquarePreview ? 30 :  20)
                                               } else {
                                                   VStack{
                                                       userSettingsViewModel.postListColor
                                                           .frame(height: 20)
                                                       userSettingsViewModel.postListColor
                                                           .frame(height: 20)
                                                           .opacity(isSquarePreview ? 0 : 1)
                                                       Spacer()
                                                   }.padding(10)
                                                       .padding(.top)
                                               }
                                               
                                               Spacer()
                                               // 背景のプレビュー（背景画像があれば表示、なければ背景色）
                                               if let bgImageName = preset.plusButton.plusButtonImageName,
                                                  let uiBGImage = UIImage(named: bgImageName) {
                                                   VStack{
                                                       Spacer()
                                                       HStack{
                                                           Spacer()
                                                           Image(uiImage: uiBGImage)
                                                               .resizable()
                                                               .scaledToFit()
                                                               .frame(height: 20)
                                                               .padding(.top, isSquarePreview ? -105 : -20)
                                                       }
                                                       .padding(.bottom, 30)
                                                       .padding(.trailing, 10)
                                                   }
                                               } else {
                                                   VStack{
                                                       Spacer()
                                                       HStack{
                                                           Spacer()
                                                           Image(systemName: "plus")
                                                               .font(.system(size: 15))
                                                               .padding(5)
                                                               .background(userSettingsViewModel.plusButtonColor)
                                                               .foregroundColor(Color.white)
                                                               .clipShape(Circle())
                                                               .padding(.top, isSquarePreview ? -110 : -20)
                                                       }
                                                       .padding(.bottom, 30)
                                                       .padding(.trailing, 10)
                                                   }
                                               }
                                           }
                                       }
                                   }
                                   .frame(width: 100, height: isSquarePreview ? 100 : 250)
                                   .cornerRadius(10)
                                   .shadow(radius: 3)
                                   .background(GeometryReader { geometry in
                                       Color.clear.preference(key: ViewPositionKey13.self, value: [geometry.frame(in: .global)])
                                   })
                                   .overlay(
                                       VStack() {
                                           Spacer()
                                           HStack{
                                               Button(action: {
                                                   generateHapticFeedback()
                                                   selectedPresetKey = key
                                                   showDeleteAlert = true
                                                   if tutorialNum == 10 {
                                                       tutorialNum = 11
                                                   }
                                               }) {
                                                   Image(systemName: "trash.square")
                                                       .font(.system(size: 30))
                                                       .foregroundColor(.red)
                                               }
                                               .opacity(isEditing ? 1 : 0)    // 非表示にする
                                               .disabled(!isEditing)
                                               .background(GeometryReader { geometry in
                                                                                       Color.clear.preference(key: ViewPositionKey15.self, value: [geometry.frame(in: .global)])
                                                                                   })
                                               .padding(.bottom, isSquarePreview ? -16 : 0)
                                               .zIndex(1)
                                               Spacer()
                                           }
                                       }.padding(.bottom)
                                   )
                                }
                            }
                        }
                    }
                }
            }
        }
            .overlay(
                ZStack {
                    Spacer()
                    HStack {
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                VStack(spacing: -20){
                                    Button(action: {
                                        generateHapticFeedback()
                                        isSquarePreview.toggle()
                                    }) {
                                        Image(isSquarePreview ? "長方形" : "四角")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height:70)
                                    }
                                    .shadow(radius: 10)
                                    .background(GeometryReader { geometry in
                                        Color.clear.preference(key: ViewPositionKey17.self, value: [geometry.frame(in: .global)])
                                    })
                                    .padding()
                                    Button(action: {
                                        generateHapticFeedback()
                                        addFlag.toggle()
                                        if tutorialNum == 3 {
                                            tutorialNum = 4
                                        }
                                    }) {
                                        if let plusButtonImageName = userSettingsViewModel.plusButtonImageName,
                                           let uiImage = UIImage(named: plusButtonImageName) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 70)
                                        } else {
                                            Image(systemName: "plus")
                                                .font(.system(size: 30))
                                                .padding(20)
                                                .background(userSettingsViewModel.plusButtonColor)
                                                .foregroundColor(Color.white)
                                                .clipShape(Circle())
                                        }
                                    }                                .background(GeometryReader { geometry in
                                        Color.clear.preference(key: ViewPositionKey11.self, value: [geometry.frame(in: .global)])
                                    })
                                    .shadow(radius: 10)
                                    .padding()
                                }
                            }
                        }
                    }
                }
            )
            .overlay(
                Group {
                    if addFlag {
                        ZStack {
                            // 背景を薄暗くしてタップをブロック
                            Color.black
                                .opacity(0.4)
                                .edgesIgnoringSafeArea(.all)

                            VStack(alignment: .center, spacing: 16) {
                                Text("現在設定しているカスタマイズを\n保存しますか？")
                                    .font(.system(size:17))
                                    .fontWeight(.bold)
                                HStack {
                                    // キャンセルボタン
                                    Button("戻る") {
                                        generateHapticFeedback()
                                        presetName = ""
                                        addFlag = false
                                    }

                                    Spacer()

                                    // 保存ボタン
                                    Button("保存") {
                                        if tutorialNum == 5 {
                                            tutorialNum = 6
                                        }
                                        generateHapticFeedback()
                                        userSettingsViewModel.savePreset()
                                        userSettingsViewModel.fetchPresets()
                                        addFlag = false
                                    }
                                    .background(GeometryReader { geometry in
                                        Color.clear.preference(key: ViewPositionKey12.self, value: [geometry.frame(in: .global)])
                                    })
                                }
                            }
                            .padding()
                            .frame(maxWidth: 300)
                            .background(Color("backgroundColor"))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        }
                    }
                    if showChangeAlert,
                       let presetKey = selectedPresetKey,
                       let preset = userSettingsViewModel.presets[presetKey] {
                            ZStack {
                                // 背景を薄暗くしてタップをブロック
                                Color.black
                                    .opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                
                                VStack(spacing: 16) {
                                    Text("このカスタマイズに変更しますか？")
                                        .font(.system(size: 17))
                                        .fontWeight(.bold)
                                        .padding(.horizontal,-20)
                                    Text("保存しないと今のカスタマイズが無くなります")
                                        .font(.caption)
                                    PresetDetailView(preset: preset)
                                    
                                    HStack {
                                        Button("やめる") {
                                            generateHapticFeedback()
                                            showChangeAlert = false
                                            selectedPresetKey = nil
                                        }
                                        Spacer()
                                        Button("変更") {
                                            if let presetKey = selectedPresetKey {
                                                
                                                print("presetKey      :\(presetKey)")
                                                userSettingsViewModel.loadPreset(name: presetKey)
                                            }
                                            generateHapticFeedback()
                                            userSettingsViewModel.fetchPresets()
                                            showChangeAlert = false
                                            selectedPresetKey = nil
                                        }
                                    }
                                }
                                .padding()
                                .frame(maxWidth: 330)
                                .background(Color("backgroundColor"))
                                .cornerRadius(10)
                                .shadow(radius: 10)
                            }
                        }
                    if showDeleteAlert,
                       let presetKey = selectedPresetKey,
                       let preset = userSettingsViewModel.presets[presetKey] {
                         ZStack {
                             // 背景を薄暗くしてタップをブロック
                             Color.black
                                 .opacity(0.4)
                                 .edgesIgnoringSafeArea(.all)
                             
                             VStack(spacing: 16) {
                                 Text("このカスタマイズを削除しますか？")
                                     .font(.system(size:17))
                                     .fontWeight(.bold)
                                     .padding(.horizontal,-20)
                                 PresetDetailView(preset: preset)
                                 HStack {
                                     Button("キャンセル") {
                                         generateHapticFeedback()
                                         showDeleteAlert = false
                                        selectedPresetKey = nil
                                         if tutorialNum == 12 {
                                             tutorialNum = 13
                                         }
                                     }
                                     Spacer()
                                     Button("削除") {
                                         if let key = selectedPresetKey {
                                             userSettingsViewModel.deletePreset(name: key)
                                             userSettingsViewModel.fetchPresets()
                                         }
                                         generateHapticFeedback()
                                        showDeleteAlert = false
                                        selectedPresetKey = nil
                                         if tutorialNum == 12 {
                                             tutorialNum = 13
                                         }
                                     }
                                     .background(GeometryReader { geometry in
                                         Color.clear.preference(key: ViewPositionKey16.self, value: [geometry.frame(in: .global)])
                                     })
                                 }
                             }
                             .padding()
                             .frame(maxWidth: 300)
                             .background(Color("backgroundColor"))
                             .cornerRadius(10)
                             .shadow(radius: 10)
                         }
                    }
                }
            )
            if tutorialNum == 1 {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        generateHapticFeedback()
                        tutorialNum = 2
                    }
                VStack {
                    Spacer()
                        //.frame(height: buttonRect.minY - bubbleHeight + 150)
                    VStack(alignment: .trailing, spacing: 15) {
                        VStack{
                        Text("ここではカスタマイズした画面を保存することができます")
                    }
                    .font(.callout)
                    .padding(5)
                    .font(.system(size: 24.0))
                    .padding(.all, 8.0)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 4)
                    .foregroundColor(Color.black)
                    .shadow(radius: 10)
                        Button(action: {
                            generateHapticFeedback()
                            tutorialNum = 2
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
                        .padding(.horizontal, 8)
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
                }
                .onTapGesture {
                    generateHapticFeedback()
                    tutorialNum = 2
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
                    Spacer()
            }
            }
            if tutorialNum == 2 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            Circle()
                                .padding(-10)
                                .frame(width: buttonRect2.width, height: buttonRect2.height)
                                .position(x: buttonRect2.midX, y: buttonRect2.midY)
                                .blendMode(.destinationOut)
                        )
                        .ignoresSafeArea()
                        .compositingGroup()
                        .background(.clear)
                        .onTapGesture {
                            generateHapticFeedback()
                            tutorialNum = 3
                        }
                }
                VStack {
                    Spacer()
                        .frame(height: buttonRect2.minY - bubbleHeight2 - 30)
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                            Spacer()
                        Text("右下のプラスボタンから\nいまのカスタマイズを保存することができます")
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
                            tutorialNum = 3
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
            if tutorialNum == 4 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .padding(-10)
                                .frame(width: buttonRect3.width, height: buttonRect3.height)
                                .position(x: buttonRect3.midX, y: buttonRect3.midY)
                                .blendMode(.destinationOut)
                        )
                        .ignoresSafeArea()
                        .compositingGroup()
                        .background(.clear)
                        .onTapGesture {
                            generateHapticFeedback()
                            tutorialNum = 5
                        }
                }
                VStack {
                    Spacer()
                        .frame(height: buttonRect3.minY - bubbleHeight3 - 30)
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                            Spacer()
                        Text("保存をタップ")
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
                            tutorialNum = 5
                        }) {
                        HStack {
                            Text("次へ")
                            Image(systemName: "chevron.forward.circle")
                        }
                        .padding(5)
                        .font(.callout)
                        .font(.system(size: 20.0))
                        .padding(.all, 8.0)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 8)
                        .foregroundColor(Color.black)
                        .shadow(radius: 10)
                        }
                    }
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
            if tutorialNum == 6 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .padding(-10)
                                .frame(width: buttonRect4.width, height: buttonRect4.height)
                                .position(x: buttonRect4.midX, y: buttonRect4.midY)
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
                        .frame(height: buttonRect4.minY - bubbleHeight4)
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                        Text("いまのカスタマイズが保存されました")
                            .font(.callout)
                            .padding(5)
                            .font(.system(size: 24.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                                Spacer()
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
                        .font(.callout)
                        .font(.system(size: 20.0))
                        .padding(.all, 8.0)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 65)
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
            if tutorialNum == 7 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .padding(-5)
                                .frame(width: buttonRect5.width, height: buttonRect5.height)
                                .position(x: buttonRect5.midX, y: buttonRect5.midY)
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
                        .frame(height: buttonRect5.minY - bubbleHeight5 + 180)
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                            Spacer()
                        Text("カスタマイズを削除する場合は\n「編集」ボタンをタップします")
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
                            tutorialNum = 8
                        }) {
                        HStack {
                            Text("次へ")
                            Image(systemName: "chevron.forward.circle")
                        }
                        .padding(5)
                        .font(.callout)
                        .font(.system(size: 20.0))
                        .padding(.all, 8.0)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 8)
                        .foregroundColor(Color.black)
                        .shadow(radius: 10)
                        }
                    }
                    .background(GeometryReader { geometry in
                        Path { _ in
                            DispatchQueue.main.async {
                                self.bubbleHeight5 = geometry.size.height
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
                                .frame(width: buttonRect6.width, height: buttonRect6.height)
                                .position(x: buttonRect6.midX, y: buttonRect6.midY)
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
                        .frame(height: buttonRect6.minY - bubbleHeight6)
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack{
                            VStack{
                        Text("左下の削除ボタンをタップ")
                            .font(.callout)
                            .padding(5)
                            .font(.system(size: 24.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                                HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 10
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.callout)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 8)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                            }
                                }.padding(.leading, 180)
                        }
                                Spacer()
                        }
                    }
                    .background(GeometryReader { geometry in
                        Path { _ in
                            DispatchQueue.main.async {
                                self.bubbleHeight6 = geometry.size.height
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
            if tutorialNum == 11 {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .padding(-5)
                                .frame(width: buttonRect7.width, height: buttonRect7.height)
                                .position(x: buttonRect7.midX, y: buttonRect7.midY)
                                .blendMode(.destinationOut)
                        )
                        .ignoresSafeArea()
                        .compositingGroup()
                        .background(.clear)
                        .onTapGesture {
                            generateHapticFeedback()
                            tutorialNum = 0
                        }
                }
                VStack {
                    Spacer()
                        .frame(height: buttonRect7.minY - bubbleHeight7 - 20)
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack{
                            Spacer()
                            VStack{
                        Text("右下のボタンをタップして\n削除することができます")
                            .font(.callout)
                            .padding(5)
                            .font(.system(size: 24.0))
                            .padding(.all, 8.0)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color.black)
                            .shadow(radius: 10)
                                HStack{
                                Button(action: {
                                    generateHapticFeedback()
                                    tutorialNum = 12
                                }) {
                                HStack {
                                    Text("次へ")
                                    Image(systemName: "chevron.forward.circle")
                                }
                                .padding(5)
                                .font(.callout)
                                .font(.system(size: 20.0))
                                .padding(.all, 8.0)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 8)
                                .foregroundColor(Color.black)
                                .shadow(radius: 10)
                            }
                                }
                                .padding(.leading , 130)
                        }
                        }
                    }
                    .background(GeometryReader { geometry in
                        Path { _ in
                            DispatchQueue.main.async {
                                self.bubbleHeight7 = geometry.size.height
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
//            if tutorialNum == 12 {
//                GeometryReader { geometry in
//                    Color.black.opacity(0.5)
//                        .overlay(
//                            Circle()
//                                .padding(-5)
//                                .frame(width: buttonRect8.width, height: buttonRect8.height)
//                                .position(x: buttonRect8.midX, y: buttonRect8.midY)
//                                .blendMode(.destinationOut)
//                        )
//                        .ignoresSafeArea()
//                        .compositingGroup()
//                        .background(.clear)
//                        .onTapGesture {
//                            generateHapticFeedback()
//                            tutorialNum = 0
//                        }
//                }
//                VStack {
//                    Spacer()
//                        .frame(height: buttonRect8.minY - bubbleHeight8 - 20)
//                    VStack(alignment: .trailing, spacing: 10) {
//                        HStack{
//                            Spacer()
//                            VStack{
//                        Text("右下のボタンをタップして\n削除することができます")
//                            .font(.callout)
//                            .padding(5)
//                            .font(.system(size: 24.0))
//                            .padding(.all, 8.0)
//                            .background(Color.white)
//                            .cornerRadius(20)
//                            .padding(.horizontal, 8)
//                            .foregroundColor(Color.black)
//                            .shadow(radius: 10)
//                                HStack{
//                                Button(action: {
//                                    generateHapticFeedback()
//                                    tutorialNum = 0
//                                }) {
//                                HStack {
//                                    Text("次へ")
//                                    Image(systemName: "chevron.forward.circle")
//                                }
//                                .padding(5)
//                                .font(.callout)
//                                .font(.system(size: 20.0))
//                                .padding(.all, 8.0)
//                                .background(Color.white)
//                                .cornerRadius(20)
//                                .padding(.horizontal, 8)
//                                .foregroundColor(Color.black)
//                                .shadow(radius: 10)
//                            }
//                                }
//                                .padding(.leading, 130)
//                        }
//                        }
//                    }
//                    .background(GeometryReader { geometry in
//                        Path { _ in
//                            DispatchQueue.main.async {
//                                self.bubbleHeight8 = geometry.size.height
//                            }
//                        }
//                    })
//                    Spacer()
//                }
//                .ignoresSafeArea()
//                VStack{
//                    Spacer()
//                    HStack{
//                        Button(action: {
//                            generateHapticFeedback()
//                            tutorialNum = 0
//                        }) {
//                            HStack {
//                                Image(systemName: "chevron.left.2")
//                                Text("スキップ")
//                            }
//                            .padding(5)
//                            .font(.system(size: 20.0))
//                            .padding(.all, 8.0)
//                            .background(Color.white)
//                            .cornerRadius(20)
//                            .padding(.horizontal, 8)
//                            .foregroundColor(Color.black)
//                            .shadow(radius: 10)
//                        }
//                        Spacer()
//                    }
//                    .padding()
//                }
//            }
        }
        .onPreferenceChange(ViewPositionKey10.self) { positions in
            self.buttonRect = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey11.self) { positions in
            self.buttonRect2 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey12.self) { positions in
            self.buttonRect3 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey13.self) { positions in
            self.buttonRect4 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey14.self) { positions in
            self.buttonRect5 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey15.self) { positions in
            self.buttonRect6 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey16.self) { positions in
            self.buttonRect7 = positions.first ?? .zero
        }
        .onPreferenceChange(ViewPositionKey17.self) { positions in
            self.buttonRect8 = positions.first ?? .zero
        }
        .background(Color("backgroundColor"))
        .onChange(of: addFlag) { newValue in
            if newValue {
                isTextFieldFocused = true
            }
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

struct PresetEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PresetEditorView(userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!))
    }
}
