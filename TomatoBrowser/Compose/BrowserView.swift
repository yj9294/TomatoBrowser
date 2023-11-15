//
//  BrowserView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/20.
//

import Foundation
import WebKit
import SwiftUI

struct BrowserView: UIViewRepresentable, Equatable {
    let id: String = UUID().uuidString
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    let webView: WKWebView
    func makeUIView(context: Context) -> some UIView {
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
