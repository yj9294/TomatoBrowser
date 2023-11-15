//
//  BrowserListContentView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/20.
//

import SwiftUI
import ComposableArchitecture

struct BrowserListContentView: View {
    let store: StoreOf<BrowserListContent>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(viewStore.items) { item in
                    getCellView(item, canDelete: viewStore.canDelete) {
                        viewStore.send(.itemDeleteButtonTapped(item))
                    } tap: {
                        viewStore.send(.itemButtonTapped(item))
                    }
                }
            }.padding(.all, 20)
        }
    }

    func getCellView(_ item: HomeContent.State, canDelete: Bool, delete: @escaping ()->Void, tap: @escaping ()->Void) -> some View {
        Button {
            tap()
        } label: {
            ZStack{
                if item.isBrowser {
                    BrowserView(webView: item.browserView).cornerRadius(6).allowsHitTesting(false).padding(.all, 1)
                }
                VStack{
                    HStack{
                        Spacer()
                        Button {
                            delete()
                        } label: {
                            Image(.tabCloseIcon)
                        }.padding(.all, 4)
                    }.padding(.all, 8).opacity(canDelete ? 1.0 : 0.0)
                    if !item.isBrowser {
                        Text(verbatim: .tabContentTitle).lineLimit(1).padding(.top, 30).foregroundColor(.black)
                    }
                    Spacer()
                }
            }
        }.cornerRadius(8).shadow(color: .shadowColor, radius: 8, x: 0, y: 2).background(RoundedRectangle(cornerRadius: 8).stroke(item.isSelected ? Color.progressColor : .gray)).frame(height: 216)
    }
}

extension Color {
    static let shadowColor = Color("#A5A5A5")
}

extension String {
    static let tabContentTitle = "Navigation"
    static let tabCloseIcon = "tab_close"
}
