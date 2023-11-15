//
//  TabList.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/20.
//

import Foundation
import ComposableArchitecture

struct BrowserList: Reducer {
    struct State: Equatable {
        var content: BrowserListContent.State
        var ad: GADNativeViewModel = .none
    }
    enum Action: Equatable {
        case content(BrowserListContent.Action)
        case back
        case add
        case ad(GADNativeViewModel)
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            switch action {
            case let .ad(ad):
                state.ad = ad
            default:
                break
            }
            return .none
        }
        Scope.init(state: \.content, action: /Action.content) {
            BrowserListContent()
        }
    }
}
