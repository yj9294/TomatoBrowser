//
//  LaunchView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/18.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<Home>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            GeometryReader { _ in
                VStack{
                    HomeSearchView(store: store.scope(state: \.search, action: Home.Action.search)).frame(height: 56).padding(.top, 42).padding(.horizontal, 20)
                    HomeContentView(store: store.scope(state: \.content, action: Home.Action.content))
                    HomeTabbarView(store: store.scope(state: \.tabbar, action: Home.Action.tabbar))
                }.background.onAppear{
                    viewStore.send(.att)
                }.alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
                .fullScreenCover(store: store.scope(state: \.$list, action: {.list($0)})) { store in
                    BrowserListView(store: store)
                }.sheet(store: store.scope(state: \.$share, action: {.share($0)})) { store in
                    ShareViwe(store: store, url: "https://itunes.apple.com/cn/app/id6471950350")
                }.fullScreenCover(store: store.scope(state: \.$privacy, action: {.privacy($0)})) { store in
                    PrivacyView(store: store)
                }.fullScreenCover(store: store.scope(state: \.$cleanAlert, action: {.cleanAlert($0)})) { store in
                    CleanAlertView(store: store).background(PresentationView(.clear))
                }.fullScreenCover(store: store.scope(state: \.$clean, action: {.clean($0)})) { store in
                    CleanView(store: store).onAppear{
                        store.send(.start)
                    }
                }.fullScreenCover(store: store.scope(state: \.$setting, action: {.setting($0)})) { store in
                    SettingView(store: store).background(PresentationView(.clear))
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: Home.State(items: StackState([.init()])), reducer: {
            Home()
        }))
    }
}
