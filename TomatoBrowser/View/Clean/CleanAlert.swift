//
//  CleanAlert.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/24.
//

import Foundation
import ComposableArchitecture

struct CleanAlert: Reducer {
    struct State: Equatable {}
    enum Action: Equatable {
        case dismiss
        case confirm
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            return .none
        }
    }
}
