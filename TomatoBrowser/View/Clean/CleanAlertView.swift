//
//  CleanAlertView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/24.
//

import SwiftUI
import ComposableArchitecture

struct CleanAlertView: View {
    let store: StoreOf<CleanAlert>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack{
                Spacer()
                VStack{
                    HStack{Spacer()}
                    Image(.cleanIcon)
                    Text(verbatim: .cleanTitle).font(.system(size: 14))
                    VStack{
                        Button {
                            viewStore.send(.confirm)
                        } label: {
                            HStack {
                                Spacer()
                                Text(verbatim: .cleanButtonTitle).padding(.vertical, 9)
                                Spacer()
                            }
                        }.background(Color.alertButtonColor.cornerRadius(22)).foregroundColor(.white)
                    }.padding(.vertical, 23).padding(.horizontal, 43)
                }.background(Color.white.cornerRadius(8)).padding(.horizontal, 56)
                Spacer()
            }.background(Color.black.ignoresSafeArea().opacity(0.5).onTapGesture {
                viewStore.send(.dismiss)
            })
        }
    }
}

extension String {
    static let cleanIcon = "clean_icon"
    static let cleanTitle = "Close Tabs and Clean Data"
    static let cleanButtonTitle = "Confirm"
}

extension Color {
    static let alertButtonColor = Color("#5D21D1")
}

struct CleanAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CleanAlertView(store: Store(initialState: CleanAlert.State(), reducer: {
            CleanAlert()
        }))
    }
}
