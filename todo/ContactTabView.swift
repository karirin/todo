//
//  ContactView.swift
//  kyuyo
//
//  Created by Apple on 2024/08/23.
//

import SwiftUI

struct ContactTabView: View {
    @State private var text: String = ""
    @State private var showAlert = false
    @ObservedObject var authManager = AuthManager()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView{
            VStack(spacing: -25) {
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
//                        audioManager.playCancelSound()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                        Text("戻る")
                    }
                    .padding(.leading)
                    .opacity(0)
                    Spacer()
//                    Text("お問合せ")
//                        .font(.system(size:24))
                    Image("お問い合わせ")
                        .resizable()
                        .frame(width:170,height:35)
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
//                        audioManager.playCancelSound()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                        Text("戻る")
                    }
                    .opacity(0)
                }
                .padding(.top)
                Spacer()
                    .frame(height: isSmallDevice() ? 100 : 120)
                Image("カスタマー")
                    .resizable()
                    .frame(width:isSmallDevice() ? 150 : 200,height:isSmallDevice() ? 150 : 200)
                Spacer()
                    .frame(height: 80)
                VStack(alignment: .center){
                    Text("改善してほしい点や\n追加を希望する機能などありましたら\nお気軽にご連絡ください\n可能な限りご要望にお応えいたします")
                        .font(.system(size:20))
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                    Spacer()
                        .frame(height: isSmallDevice() ? 0 : 50)
                    TextField(
                        "",
                        text: $text,
                        axis: .vertical
                    )
                    .padding()
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    Button(action: {
                        authManager.updateContact(userId: authManager.currentUserId!, newContact: text){ success in
                            self.showAlert = true
                            self.text = ""
                        }
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }, label: {
                        Text("送信")
                            .fontWeight(.semibold)
                            .frame(width: 130, height:40)
                            .foregroundColor(Color.white)
                            .background(Color.gray)
                            .cornerRadius(24)
                    })
                    .opacity(text.isEmpty ? 0.5 : 1)
                    .disabled(text.isEmpty)
                    .shadow(radius: 3)
                    .padding(.top,10)
                    .alert(isPresented: $showAlert) { // アラートを表示する
                        Alert(
                            title: Text("送信されました"),
                            message: Text("お問合せありがとうございます"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                Spacer()
            }
        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        .navigationBarItems(leading: Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//            audioManager.playCancelSound()
//        }) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(Color("fontGray"))
//            Text("戻る")
//                .foregroundColor(Color("fontGray"))
//        })
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .frame(maxHeight:.infinity)
        .background(Color("backgroundColor"))
        .foregroundColor(Color("fontGray"))
    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
}

#Preview {
    ContactTabView()
}


