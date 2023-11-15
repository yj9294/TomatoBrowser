//
//  HomeSearchReducer.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/19.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HomeSearch: Reducer {
    struct State: Equatable {
        @BindingState var text: String = ""
        var isLoading: Bool = false
    }
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case search
        case stop
    }
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            return .none
        }
    }
}

extension Notification.Name {
    static let search = Notification.Name(rawValue: "search")
    static let stop = Notification.Name(rawValue: "stop.search")
}
