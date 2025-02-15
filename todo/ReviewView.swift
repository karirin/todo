//
//  HelpModalView.swift
//  chatAi
//
//  Created by Apple on 2024/02/20.
//

import SwiftUI
import StoreKit

struct ReviewView: View {
    @ObservedObject var authManager = AuthManager()
    @Binding var isPresented: Bool
    @Binding var helpFlag: Bool
    @State var toggle = false
    @State private var text: String = ""
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert?
    @Environment(\.requestReview) var requestReview
    enum ActiveAlert: Identifiable {
        case satisfied, dissatisfied
        
        var id: Int {
            hashValue
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            VStack(spacing: -25) {
                VStack(alignment: .center){
                    Text("")
                    Text("アプリの使い心地はどうですか ？")
                        .font(.system(size: isSmallDevice() ? 18 : 20))
                        .fontWeight(.bold)
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            activeAlert = .satisfied
                        }, label: {
                            VStack{
                                Image("満足")
                                    .resizable()
                                    .frame(width:80,height: 80)
                                Text("満足").fontWeight(.bold)
                            }
                        })
                        Spacer()
                        Button(action: {
                            activeAlert = .dissatisfied
                        }, label: {
                            VStack{
                                Image("不満")
                                    .resizable()
                                    .frame(width:80,height: 80)
                                    .padding(.bottom,3)
                                Text("不満")
                                    .fontWeight(.bold)
                            }
//                            .padding(.bottom,8)
                        })
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Toggle("今後は表示しない", isOn: $toggle)
                            .frame(width:200)
                            .toggleStyle(SwitchToggleStyle())
                            .padding(.horizontal)
                            .padding(.top,5)
                    }
                }
            }
            .alert(item: $activeAlert) { alert in
                switch alert {
                case .satisfied:
                    return Alert(
                        title: Text("ありがとうございます！"),
                        message: Text("\nサービス向上の励みになりますので\nよろしければレビューお願いします🙇‍♂️"),
                        dismissButton: .default(Text("OK")) {
                            requestReview()
                            isPresented = false
                            authManager.updateUserReviewFlag(userId: authManager.currentUserId!, userFlag: 1) { success in
                            }
                        }
                    )
                case .dissatisfied:
                    return Alert(
                        title: Text("回答ありがとうございます！"),
                        message: Text("サービス向上のため\nご意見お聞かせください🙇‍♂️"),
                        dismissButton: .default(Text("OK")) {
                            helpFlag = true
                            isPresented = false
                            authManager.updateUserReviewFlag(userId: authManager.currentUserId!, userFlag: 1) { success in
                            }
                        }
                    )
                }
            }
            .frame(width: isSmallDevice() ? 290: 320)
            .foregroundColor(Color("fontGray"))
            .padding()
        .background(Color("backgroundColor"))
        .cornerRadius(20)
        .shadow(radius: 10)
        .overlay(
            // 「×」ボタンを右上に配置
            Button(action: {
                if toggle == true {
                    authManager.updateUserReviewFlag(userId: authManager.currentUserId!, userFlag: 1) { success in
                    }
                }
                isPresented = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                    .background(.white)
                    .cornerRadius(30)
                    .padding()
            }
                .offset(x: 35, y: -35), // この値を調整してボタンを正しい位置に移動させます
            alignment: .topTrailing // 枠の右上を基準に位置を調整します
        )
        .padding(25)
                }
//            }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        print(store.productList)
                    }
                }
            //            .padding(50)
          
        }
//    }
    
    func isSmallDevice() -> Bool {
        return UIScreen.main.bounds.width < 390
    }
}

#Preview {
    ReviewView(isPresented: .constant(true), helpFlag: .constant(true))
}
