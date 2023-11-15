//
//  LaunchReducer.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/18.
//

import SwiftUI
import ComposableArchitecture

struct Launch: Reducer {
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }
    struct State: Equatable {
        var progress: Double = 0.0
        
        var launched = false
        var isLaunched: Bool {
            progress >= 1.0
        }
        fileprivate var duration = 12.5
        fileprivate let interval = Duration.milliseconds(10)
    }
    enum Action: Equatable {
        case startLoading
        case update
        case updateDuration
        case stopLoading
        case checkLoadedAD
        
        case launched
    }
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startLoading:
                if state.launched {
                    return .none
                }
                let interval = state.interval
                state.progress = 0.0
                state.duration = 12.5
                state.launched = false
                Task{
                    try? await GADUtil.share.load(.interstitial)
                }
                Task{
                    try? await GADUtil.share.load(.open)
                }
                Task{
                    try? await GADUtil.share.load(.native)
                }
                return .run { send in
                    for await _ in clock.timer(interval: interval) {
                        await send(.update)
                        await send(.checkLoadedAD)
                    }
                }.cancellable(id: CancelID.timer)
            case .update:
                let interval = state.interval.inMilliseconds
                state.progress += interval  / state.duration
                if state.progress > 1.0 {
                    state.progress = 1.0
                    return .run { send in
                        await send(.stopLoading)
                        await GADUtil.share.show(.open)
                        await send(.launched)
                    }
                }
            case .checkLoadedAD:
                let progress = state.progress
                return .run{ send in
                    do {
                        let _ = try await GADUtil.share.load(.open)
                        if progress > 0.2 {
                            await send(.updateDuration)
                        }
                    } catch let err {
                        if (err as? GADPreloadError) != GADPreloadError.loading, progress > 0.2 {
                            await send(.updateDuration)
                        }
                    }
                }
            case .updateDuration:
                state.duration = 0.02
            case .stopLoading:
                return .cancel(id: CancelID.timer)
            case .launched:
                state.launched = true
            }
            return .none
        }
    }
}

extension Duration {
    var inMilliseconds: Double {
        let v = components
        return (Double(v.seconds) * 1000 + Double(v.attoseconds) * 1e-15) / 1000
    }
}
