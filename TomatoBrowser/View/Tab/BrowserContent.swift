//
//  BrowserContent.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/20.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct BrowserListContent: Reducer {
    struct State: Equatable {
        var items: StackState<HomeContent.State>
    }
    enum Action: Equatable {
        case item(StackAction<HomeContent.State, HomeContent.Action>)
        case itemDeleteButtonTapped(HomeContent.State)
        case itemButtonTapped(HomeContent.State)
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            switch action {
            case let .itemDeleteButtonTapped(item):
                let newItems = state.items.filter{
                    $0 != item
                }
                if !item.isSelected {
                    state.items = StackState(newItems)
                } else {
                    if let item = newItems.first {
                        state.items = selected(item, in: StackState(newItems))
                    }
                }
            case let .itemButtonTapped(item):
                state.items = unSelected(in: state.items)
                state.items = selected(item, in: state.items)
            default:
                break
            }
            return .none
        }.forEach(\.items, action: /Action.item) {
            HomeContent()
        }
    }
}

extension BrowserListContent.State {
    
    var canDelete: Bool {
        items.count > 1
    }
    
    var item: HomeContent.State {
        items.filter {$0.isSelected}.first ?? .init()
    }
    
}
