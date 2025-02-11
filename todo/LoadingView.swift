//
//  LoadingView.swift
//  todo
//
//  Created by Apple on 2025/02/08.
//

import SwiftUI

struct LoadingView: View {
        @State private var activeIndex = 0          // 現在アクティブな文字のインデックス
        @State private var isUp = false             // 文字が上がっているかどうか
        @State private var imageScaled = false      // ライム画像がスケールアップしているかどうか
        @State private var limeSpring = false       // ライム画像のスプリングアニメーション用フラグ
        
        private let text = "Loading…"                 // 表示するテキスト
        private let waveHeight: CGFloat = 10         // 文字が上がる高さ
        private let animationDuration: Double = 0.2   // アニメーションの持続時間（秒）
        private let delayBetweenLetters: Double = 0.05 // 文字間の遅延時間（秒）
        
        var body: some View {
            VStack(spacing: 8) { // 画像と文字間のスペースを調整
                // ライムの画像
                Image("ロゴ")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .scaleEffect(imageScaled ? 1.0 : 0.5) // 初期ポップイン用のスケール効果
                    .scaleEffect(limeSpring ? 1.2 : 1.0)    // スプリングアニメーション用のスケール効果
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0),
                        value: imageScaled
                    )
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0),
                        value: limeSpring
                    )
                
                // "Loading…" の文字
                HStack(spacing: 5) {
                    ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                        Text(String(character))
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color.black)
                            .offset(y: (index == activeIndex && isUp) ? -waveHeight : 0) // アクティブな文字のみオフセットを適用
                            .animation(
                                Animation.easeInOut(duration: animationDuration),
                                value: isUp
                            )
                    }
                }
            }
            .onAppear {
                startImageAndSequentialAnimation() // ビューが表示されたときにアニメーションを開始
            }
        }
        
        /// 画像のポップインと文字の順次アニメーションを開始する関数
        func startImageAndSequentialAnimation() {
            Task {
                // ライムの画像をポップインさせる
                withAnimation {
                    imageScaled = true
                }
                // ポップインアニメーションの完了を待機（アニメーション時間 + マージン）
                try? await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000)) // 0.5秒待機
                
                // 文字の順次アニメーションを開始
                startSequentialAnimation()
            }
        }
        
        /// 文字の順次アニメーションを開始する関数
        func startSequentialAnimation() {
            Task {
                while true {
                    // 現在の文字を上昇させる
                    withAnimation {
                        isUp = true
                    }
                    // アニメーションの上昇部分を待機
                    try? await Task.sleep(nanoseconds: UInt64(animationDuration * 1_000_000_000)) // 0.2秒
                    
                    // 現在の文字を下降させる
                    withAnimation {
                        isUp = false
                    }
                    // アニメーションの下降部分を待機
                    try? await Task.sleep(nanoseconds: UInt64(animationDuration * 1_000_000_000)) // 0.2秒
                    
                    // 「g」のアニメーションが完了した場合、ライム画像をスプリングさせる
                    if activeIndex == text.count - 1 { // 最後の文字（"g"）のインデックス
                        withAnimation {
                            limeSpring = true
                        }
                        // スプリングアニメーションの完了を待機
                        try? await Task.sleep(nanoseconds: UInt64(0.3 * 1_000_000_000)) // 0.3秒待機
                        
                        // スプリングアニメーションをリセット
                        withAnimation {
                            limeSpring = false
                        }
                    }
                    
                    // 次の文字に移行
                    activeIndex = (activeIndex + 1) % text.count
                    
                    // 文字間の遅延を追加
                    try? await Task.sleep(nanoseconds: UInt64(delayBetweenLetters * 1_000_000_000)) // 0.05秒
                }
            }
        }
    }

#Preview {
    LoadingView()
}
