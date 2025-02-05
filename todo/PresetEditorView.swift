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
    
    var body: some View {
        VStack {
            Button(action: {
                addFlag.toggle()
            }) {
                Text("追加")
            }
            ZStack {
                VStack{
                    if let headerImageName = userSettingsViewModel.settings.header.headerImageName,
                       let uiHeaderImage = UIImage(named: headerImageName) {
                        Image(uiImage: uiHeaderImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 20)
                        
                            .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                            .padding(.bottom, -20)
                            .padding(.top,10)
                            .zIndex(1)
                    } else {
                        userSettingsViewModel.headerColor
                            .frame(height: 20)
                            .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                            .padding(.bottom, -10).zIndex(1)
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
                                        .padding(.top, -20)
                                }
                                .padding(.bottom, 30)
                                .padding(.trailing, 10)
                            }
                        }
                    }
                }
        }
            .frame(width: 100,height: 250)
        .cornerRadius(10)
        .shadow(radius: 3)
        
            ScrollView {
                HStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                        ForEach(Array(userSettingsViewModel.presets.keys).sorted(), id: \.self) { key in
                            if let preset = userSettingsViewModel.presets[key] {
                                Button(action: {
                                    userSettingsViewModel.loadPreset(name: key)
                                }) {
                                    ZStack {
                                       VStack{
                                           if let headerImageName = preset.header.headerImageName ,
                                              let uiHeaderImage = UIImage(named: headerImageName) {
                                               Image(uiImage: uiHeaderImage)
                                                   .resizable()
                                                   .scaledToFill()
                                                   .frame(height: 20)
                                               
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
                                                               .padding(.top, -20)
                                                       }
                                                       .padding(.bottom, 30)
                                                       .padding(.trailing, 10)
                                                   }
                                               }
                                           }
                                       }
                                   }
                                       .frame(width: 100,height: 250)
                                   .cornerRadius(10)
                                   .shadow(radius: 3)
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(Color("backgroundColor"))
        .sheet(isPresented: $addFlag) {
            // 現在の設定をプリセットとして保存するセクション
            VStack(alignment: .leading, spacing: 10) {
                Text("現在の設定をプリセットとして保存")
                    .font(.headline)
                HStack {
                    TextField("プリセット名を入力", text: $presetName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        // 入力が空でなければ保存
                        guard !presetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        userSettingsViewModel.savePreset(name: presetName)
                        presetName = ""
                        userSettingsViewModel.fetchPresets()
                    }) {
                        Text("保存")
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

struct PresetEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PresetEditorView(userSettingsViewModel: UserSettingsViewModel(userID: AuthManager().currentUserId!))
    }
}
