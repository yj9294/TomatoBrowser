//
//  Setting.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/23.
//

import Foundation
import ComposableArchitecture

struct Setting: Reducer {
    struct State: Equatable {}
    enum Action: Equatable {
        case dismiss
        case add
        case share
        case copy
        case rate
        case privacy
        case terms
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            return .none
        }
    }
}

extension Setting.State {
    enum Item: String, CaseIterable, Equatable {
        case new, share, copy, rate, privacy, terms
        
        var title: String {
            switch self {
            case .new, .share, .copy:
                return rawValue.capitalized
            case .rate:
                return .rate
            case .privacy:
                return .privacy
            case .terms:
                return .terms
            }
        }
        var icon: String {
            rawValue
        }
        
        var isColumn: Bool {
            switch self {
            case .rate, .privacy, .terms:
                return true
            default:
                return false
            }
        }
        var isRow: Bool {
            !isColumn
        }
    }
}
