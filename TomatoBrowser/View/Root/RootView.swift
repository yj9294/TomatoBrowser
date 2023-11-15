//
//  ContentView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/18.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<Root>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            contentView(with: viewStore.item).onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                viewStore.send(.enterForeground)
            }
        }
    }
    
    func contentView(with item: Root.State.Item) -> some View {
        VStack {
            switch item {
            case .launch:
                LaunchView(store: store.scope(state: \.launch, action: Root.Action.launch))
            case .home:
                HomeView(store: store.scope(state: \.home, action: Root.Action.home))
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Store(initialState: Root.State(), reducer: {
            Root()
        }))
    }
}
