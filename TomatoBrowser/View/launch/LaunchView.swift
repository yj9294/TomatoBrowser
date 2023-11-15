//
//  LaunchView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/18.
//

import SwiftUI
import ComposableArchitecture

struct LaunchView: View {
    let store: StoreOf<Launch>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack{
                HStack {
                    Spacer()
                    Image(.launchIcon).padding(.top, 178)
                    Spacer()
                }
                Image(.launchTitle).padding(.top, 45)
                Spacer()
                HStack{
                    GeometryReader{ proxy in
                        HStack(spacing: 0){
                            Color.progressColor.cornerRadius(2.5).frame(width: proxy.size.width * viewStore.progress)
                            Color.progressBackgroundColor
                        }
                    }.frame(height: 5).cornerRadius(2.5)
                }.padding(.bottom, 44).padding(.horizontal, 70)
            }.background.onAppear{
                viewStore.send(.startLoading)
            }.onDisappear{
                viewStore.send(.stopLoading)
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(store: Store(initialState: Launch.State(), reducer: {
            Launch()
        }))
    }
}
