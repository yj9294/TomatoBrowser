//
//  CleanView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/24.
//

import SwiftUI
import ComposableArchitecture

struct CleanView: View {
    let store: StoreOf<Clean>
    @State private var beigin = false
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack{
                Spacer()
                ZStack{
                    Image(.cleanAnimation).rotationEffect(.degrees(beigin ? 1080 : 0)).animation(.linear(duration: 12.5), value: beigin)
                    Image(.cleanTrash)
                }
                Text(verbatim: .cleanBody).font(.system(size: 16)).padding(.top, 80)
                Spacer()
                HStack{Spacer()}
            }.background.onAppear{
                viewStore.send(.start)
                beigin = true
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { _ in
                viewStore.send(.appEnterbackground)
            }).onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
                viewStore.send(.appEnterforeground)
            })
        }
    }
}

extension String {
    static let cleanTrash = "clean_trash"
    static let cleanAnimation = "clean_animation"
    static let cleanBody = "cleaning..."
    static let cleanSuccess = "Clean successfully."
}

struct CleanView_Previews: PreviewProvider {
    static var previews: some View {
        CleanView(store: Store(initialState: Clean.State(), reducer: {
            Clean()
        }))
    }
}
