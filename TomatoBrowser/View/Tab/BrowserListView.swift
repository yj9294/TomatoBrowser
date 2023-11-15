//
//  BrowserListView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/20.
//

import SwiftUI
import ComposableArchitecture

struct BrowserListView: View {
    let store: StoreOf<BrowserList>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack{
                ScrollView{
                    BrowserListContentView(store: store.scope(state: \.content, action: BrowserList.Action.content))
                }
                Spacer()
                HStack{
                    GADNativeView(model: viewStore.ad)
                }.frame(height: 124).padding(.horizontal, 20)
                getBottomView {
                    viewStore.send(.add)
                } back: {
                    viewStore.send(.back)
                }
            }.background.onReceive(NotificationCenter.default.publisher(for: .nativeUpdate)) { noti in
                if let obj = noti.object as? GADNativeModel {
                    store.send(.ad(.init(model: obj)))
                }
            }
        }
    }
    
    func getBottomView(add:@escaping ()->Void, back: @escaping ()->Void) -> some View {
        ZStack{
            HStack{
                Spacer()
                Button(action: add) {
                    Image(.tabAddIcon)
                }
                Spacer()
            }
            HStack{
                Spacer()
                Button(action: back) {
                    Text(verbatim: .tabBackTitle).font(.system(size: 14)).padding(.trailing, 18)
                }
            }
        }
    }
}

extension String {
    static let tabAddIcon = "tab_add"
    
    static let tabBackTitle = "back"
}
