//
//  HomeContentView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/19.
//

import SwiftUI
import ComposableArchitecture

struct HomeContentView: View {
    let store: StoreOf<HomeContent>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack{
                if viewStore.isLoading {
                    ProgressView("", value: viewStore.progress).tint(.progressColor)
                }
                getContentView(viewStore.state) { item in
                    viewStore.send(.itemButtonTapped(item))
                }
                Spacer()
            }.onReceive(NotificationCenter.default.publisher(for: .search)) { _ in
                viewStore.send(.searchButtonTapped)
            }.onReceive(NotificationCenter.default.publisher(for: .stop)) { _ in
                viewStore.send(.stopButtonTapped)
            }.onReceive(NotificationCenter.default.publisher(for: .nativeUpdate)) { noti in
                if let obj = noti.object as? GADNativeModel {
                    store.send(.ad(.init(model: obj)))
                }
            }
        }
    }
    
    func getContentView(_ viewStore: HomeContent.State, action: @escaping (HomeContent.State.Item)->Void ) -> some View {
        VStack{
            if viewStore.isBrowser {
                BrowserView(webView: viewStore.browserView)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing: 28) {
                        ForEach(viewStore.items, id: \.self) { item in
                            Button(action: {
                                action(item)
                            }, label: {
                                VStack{
                                    Image(item.icon)
                                    Text(item.title)
                                }
                            }).font(.system(size: 13.0)).foregroundColor(.textColor)
                        }
                    }.padding(.top, 38)
                }
                Image(.homecontentIcon).padding(.top, 19)
                Spacer()
                HStack{
                    GADNativeView(model: viewStore.ad)
                }.frame(height: 124).padding(.horizontal, 20)
                Spacer()
            }
        }
    }
}

extension Color {
    static let textColor = Color("#3B3A3A")
}

extension String {
    static let homecontentIcon = "home_content_icon"
}
