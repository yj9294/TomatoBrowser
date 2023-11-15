//
//  RootReducer.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/18.
//

import Foundation
import ComposableArchitecture

struct Root: Reducer {
    struct State: Equatable {
        var item: Item = .launch
        var home: Home.State = .init(items: StackState([.init()]))
        var launch: Launch.State = .init()
        
        var homeImpressionDate: Date = .init(timeIntervalSinceNow: -11)
        var listImpressionDate: Date = .init(timeIntervalSinceNow: -11)
    }
    
    enum Action: Equatable{
        case home(Home.Action)
        case launch(Launch.Action)
        case enterForeground
        
        case loadingAD(GADShowPosition = .home)
        case cleanAD
        case updateAD(GADNativeViewModel?, GADShowPosition = .home)
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .launch(launchAction):
                if launchAction == .launched, state.launch.isLaunched {
                    state.item = .home
                    return .run { send in
                        await send(.loadingAD())
                    }
                }
            case let .home(action):
                switch action {
                case .cleanAD:
                    return .run { send in
                        await send(.cleanAD)
                    }
                case let .loadingAD(postion):
                    return .run { send in
                        await send(.loadingAD(postion))
                    }
                default:
                    break
                }
            case .enterForeground:
                state.launch.launched = false
                state.item = .launch
                return .run{ send in
                    await GADUtil.share.dismiss()
                }
            case let .loadingAD(postion):
                return .run { send in
                    do {
                        _ = try await GADUtil.share.load(.native)
                        let model = await GADUtil.share.show(.native) as? GADNativeModel
                        await send(.updateAD(.init(model: model), postion))
                    } catch let err {
                        if (err as? GADPreloadError) != .loading {
                            await send(.updateAD(nil, postion))
                        }
                    }
                }
            case let .updateAD(model, postion):
                if let model = model, postion == .home {
                    if state.isAllowImpressionHome {
                        state.home.content.ad = model
                        state.homeImpressionDate = Date()
                    }
                } else if let model = model, postion == .list {
                    if state.isAllowImpressionList {
                        state.home.list?.ad = model
                        state.listImpressionDate = Date()
                    }
                } else {
                    state.home.content.ad = .none
                    state.home.list?.ad = .none
                }
                
            case .cleanAD:
                GADUtil.share.disappear(.native)
                return .run{ send in
                    await send(.updateAD(nil))
                }
            }
            return .none
        }
        
        Scope(state: \.home, action: /Action.home) {
            Home()
        }
        Scope(state: \.launch, action: /Action.launch) {
            Launch()
        }
    }
}

extension Root.State {
    
    enum Item: Equatable {
        case launch, home
    }
    
    var isAllowImpressionHome: Bool {
        if Date().timeIntervalSince(homeImpressionDate) <= 10 {
            debugPrint("[ad] home native ad 间隔小于10秒 ")
            return false
        } else {
            return true
        }
    }
    
    var isAllowImpressionList: Bool {
        if Date().timeIntervalSince(listImpressionDate) <= 10 {
            debugPrint("[ad] list native ad 间隔小于10秒 ")
            return false
        } else {
            return true
        }
    }
}

enum GADShowPosition {
    case home, list
}
