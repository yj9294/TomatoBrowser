//
//  HomeTabbarView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/19.
//

import SwiftUI
import ComposableArchitecture

struct HomeTabbarView: View {
    let store: StoreOf<HomeTabbar>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            HStack{
                ForEach(viewStore.items, id:\.self) { item in
                    getItemView(item, with: viewStore.state) {
                        viewStore.send(.tabbarButtonTapped(item))
                    }
                }
            }
        }
    }
    
    func getItemView(_ item: HomeTabbar.State.Item, with viewStore: HomeTabbar.State, action: @escaping ()->Void) -> some View {
        VStack{
            if item == .left, !viewStore.canGoBack {
                Image(item.icon).opacity(0.5)
            } else if item == .right, !viewStore.canGoForward {
                Image(item.icon).opacity(0.5)
            } else {
                Button(action: action) {
                    ZStack {
                        Image(item.icon)
                        if item == .tab {
                            Text(viewStore.countString).font(.system(size: 13)).foregroundColor(.textColor)
                        }
                    }
                }
            }
        }.padding(20).frame(height: 50)
    }
}

struct HomeTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabbarView(store: Store(initialState: HomeTabbar.State(), reducer: {
            HomeTabbar()
        }))
    }
}
