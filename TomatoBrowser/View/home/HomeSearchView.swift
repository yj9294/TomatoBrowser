//
//  HomeSearchView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/19.
//

import SwiftUI
import ComposableArchitecture

struct HomeSearchView: View {
    let store: StoreOf<HomeSearch>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            HStack{
                TextField("", text: viewStore.$text, prompt: Text(verbatim: .searchPlaceholder)).padding(.all, 16)
                Spacer()
                Button {
                    viewStore.send(viewStore.isLoading ? .stop : .search)
                } label: {
                    Image(viewStore.isLoading ? .stopIcon :  .searchIcon)
                }.padding(.all, 16)
            }.background(Color.searchBackgroundColor).cornerRadius(8)
        }
    }
}

// color
extension Color {
    fileprivate static let searchBackgroundColor = Color("#F4E0E1")
    fileprivate static let searchPlaceholderTextColor = Color("#CAB5B6")
}

extension String {
    static let searchPlaceholder = "Search or enter an address"
    static let searchFailed = "Please enter your search content."
}

extension String {
    static let searchIcon = "home_search"
    static let stopIcon = "home_stop"
}

struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchView(store: Store(initialState: HomeSearch.State(), reducer: {
            HomeSearch()
        }))
    }
}
