//
//  BackgroundModifier.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/19.
//

import SwiftUI

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            VStack(spacing: 0){
                LinearGradient.linearGradient(colors: [.startColor, .endColor], startPoint: .top, endPoint: .bottom).frame(height: 140)
                Color.endColor
            }.ignoresSafeArea()
        )
    }
}

extension View {
    var background: some View {
        self.modifier(BackgroundModifier())
    }
}
