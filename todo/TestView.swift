//
//  TestView.swift
//  todo
//
//  Created by Apple on 2025/01/31.
//

import SwiftUI

struct LightningShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // 左端から右端への水平線を描画
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

struct LightningAnimationView: View {
    @State private var moveDown = false
    @State private var currentColorIndex = 0
    @State private var timer: Timer? = nil // タイマーを管理するための状態変数
    let colors: [Color] = [.yellow, .blue, .red, .green, .purple]
    
    var body: some View {
        GeometryReader { geometry in
            LightningShape()
                .stroke(colors[currentColorIndex], lineWidth: 10)
                .frame(width: geometry.size.width, height: 2) // 幅を画面幅に、高さを小さく設定
                .position(x: geometry.size.width / 2, y: moveDown ? geometry.size.height + 50 : -50) // y座標をアニメーションで変更
                .animation(Animation.linear(duration: 2), value: moveDown) // アニメーションを一度だけ実行
                .onAppear {
                    moveDown = true
                    // タイマーを設定して色を定期的に変更
                    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        withAnimation(.linear(duration: 1)) {
                            currentColorIndex = (currentColorIndex + 1) % colors.count
                        }
                    }
                    
                    // アニメーション完了後にタイマーを無効化
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        timer?.invalidate()
                        timer = nil
                    }
                }
                .onDisappear {
                    // ビューが消える際にタイマーを無効化
                    timer?.invalidate()
                    timer = nil
                }
        }
    }
}

struct TestView: View {
    var body: some View {
        LightningAnimationView()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
