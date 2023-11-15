//
//  HomeTabbar.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/19.
//

import Foundation
import ComposableArchitecture

struct HomeTabbar: Reducer {
    struct State: Equatable {
        var items: [Item] = Item.allCases
        var count: Int = 1
        var canGoBack: Bool = false
        var canGoForward: Bool = false
    }
    enum Action: Equatable {
        case tabbarButtonTapped(State.Item)
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            return .none
        }
    }
}

extension HomeTabbar.State {
    var  countString: String {
        "\(count)"
    }
    enum Item: String, Equatable, CaseIterable {
        case left, right, clean, tab, settings
        var icon: String {
            "home_\(self.rawValue)"
        }
    }
}
