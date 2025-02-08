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
    @State private var isSquarePreview: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("カスタマイズ一覧")
                    .foregroundColor(userSettingsViewModel.headerTextColor)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .padding(.horizontal,5)
                    .background(Color("backgroundColor").opacity(userSettingsViewModel.headerOpacityFlag ? 0.6 : 0))
                    .cornerRadius(10)
                Spacer()
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
                    if let headerImageName = userSettingsViewModel.settings.header.headerImageName,
                       let uiHeaderImage = UIImage(named: headerImageName) {
                        Image(uiImage: uiHeaderImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: isSquarePreview ? 100 : 20)
                        
                            .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                            .padding(.bottom, -30)
                            .padding(.top, 20)
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
                                Image(uiImage: uiBGImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                Spacer()
                            }.padding(10)
                                .padding(.top)
                        } else {
                            VStack{
                                userSettingsViewModel.postListColor
                                    .frame(height: 20)
                                userSettingsViewModel.postListColor
                                    .frame(height: 20)
                                Spacer()
                            }.padding(10)
                                .padding(.top)
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
                                        .padding(.top, -20)
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
        }
        .frame(width: 100, height: isSquarePreview ? 100 : 250)
        .cornerRadius(10)
        .shadow(radius: 3)
        
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
                                                   .frame(height: isSquarePreview ? 120 : 20)
                                               
                                                   .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                                                   .padding(.bottom, -20)
                                                   .padding(.top,10)
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
                                                       Image(uiImage: uiPLImage)
                                                           .resizable()
                                                           .scaledToFit()
                                                           .frame(height: 20)
                                                       Spacer()
                                                   }.padding(10)
                                                       .padding(.top)
                                               } else {
                                                   VStack{
                                                       userSettingsViewModel.postListColor
                                                           .frame(height: 20)
                                                       userSettingsViewModel.postListColor
                                                           .frame(height: 20)
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
                                                               .padding(.top, -20)
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
                                   .overlay(
                                       VStack() {
                                           Spacer()
                                           HStack{
                                               Button(action: {
                                                   generateHapticFeedback()
                                                   selectedPresetKey = key
                                                   showDeleteAlert = true
                                               }) {
                                                   Image(systemName: "trash.square.fill")
                                                       .font(.system(size: 30))
                                               }
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
        .background(Color("backgroundColor"))
        .onChange(of: addFlag) { newValue in
            if newValue {
                isTextFieldFocused = true
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
                                .padding()
                                Button(action: {
                                    generateHapticFeedback()
                                    addFlag.toggle()
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
                                }
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
                                    generateHapticFeedback()
                                    userSettingsViewModel.savePreset()
                                    userSettingsViewModel.fetchPresets()
                                    addFlag = false
                                }
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
                                 }
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
