//
//  SettingView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/23.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    let store: StoreOf<Setting>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    VStack{
                        HStack{
                            getItemView(.new) {
                                viewStore.send(.add)
                            }
                            Spacer()
                            getItemView(.share) {
                                viewStore.send(.share)
                            }
                            Spacer()
                            getItemView(.copy) {
                                viewStore.send(.copy)
                            }
                        }
                        VStack{
                            getItemView(.rate) {
                                viewStore.send(.rate)
                            }
                            getItemView(.privacy) {
                                viewStore.send(.privacy)
                            }
                            getItemView(.terms) {
                                viewStore.send(.terms)
                            }
                        }
                    }.padding(.horizontal, 16).frame(width: 250, height: 240).background(Color.white.cornerRadius(6))
                }.padding(.bottom, 26).padding(.trailing, 26)
            }.background(Color.black.ignoresSafeArea().opacity(0.5).onTapGesture {
                viewStore.send(.dismiss)
            })
        }
    }
    
    func getItemView(_ item: Setting.State.Item, action: @escaping ()->Void) -> some View{
        Button(action: action) {
            VStack {
                if item.isRow {
                    VStack{
                        Image(item.icon)
                        Text(item.title)
                    }
                } else if item.isColumn {
                    HStack {
                        Text(item.title)
                        Spacer()
                        Image(.settingArrow)
                    }.padding(.vertical, 8)
                }
            }
        }.foregroundColor(.settingTextColor).font(.system(size: 14))

    }
}

extension Color {
    static let settingTextColor = Color("#676767")
}

extension String {
    static let settingArrow = "setting_arrow"
    static let rate = "Rate Us"
    static let privacy = "Privacy Policy"
    static let terms = "Terms of User"
    static let copySuccess = "Copy successfully."
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(store: Store(initialState: Setting.State(), reducer: {
            Setting()
        }))
    }
}
