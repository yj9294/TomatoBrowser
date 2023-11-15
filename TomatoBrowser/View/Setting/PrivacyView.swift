//
//  PrivacyView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/23.
//

import SwiftUI
import ComposableArchitecture

struct PrivacyView: View {
    let store: StoreOf<Privacy>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack{
                ZStack{
                    HStack{
                        Button {
                            viewStore.send(.dismiss)
                        } label: {
                            Image(.backIcon).padding(.leading, 16)
                        }
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text(viewStore.item.title)
                        Spacer()
                    }
                }.padding(.top, 10)
                Spacer()
                ScrollView {
                    Text(viewStore.item.body).font(.system(size: 14)).foregroundColor(.textColor).padding()
                }
            }.background
        }
    }
}

extension Color {
    static let privacyTextColor = Color("#666666")
}

extension String {
    static let backIcon = "back"
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView(store: Store(initialState: Privacy.State(), reducer: {
            Privacy()
        }))
    }
}
