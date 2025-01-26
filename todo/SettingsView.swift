//
//  SettingsView.swift
//  todo
//
//  Created by Apple on 2025/01/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // 背景色変更セクション
                    NavigationLink(destination: BackgroundColorView(userSettingsViewModel: userSettingsViewModel)) {
                        HStack {
                            Image(systemName: "paintbrush")
                                .foregroundColor(.blue)
                            Text("背景色を変更")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 2)
                    }
                    
                    // 背景画像変更セクション
                    NavigationLink(destination: BackgroundImageView(userSettingsViewModel: userSettingsViewModel)) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .foregroundColor(.purple)
                            Text("背景画像を変更")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 2)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("設定")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userSettingsViewModel: UserSettingsViewModel(userID: "mockUserID123"))
    }
}
