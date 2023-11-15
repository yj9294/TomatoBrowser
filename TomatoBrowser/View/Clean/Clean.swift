//
//  Clean.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/24.
//

import Foundation
import ComposableArchitecture

struct Clean: Reducer {
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }
    struct State: Equatable {
        var isStart = false
        var isBackground = false
        fileprivate var progress: Double = 0.0
        fileprivate var duration = 12.5
        fileprivate let interval = Duration.milliseconds(1000)
    }
    enum Action: Equatable {
        case dismiss
        case start
        case update
        case updateDuration
        case checkLoadedAD
        case stopLoading
        case appEnterbackground
        case appEnterforeground
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            switch action {
            case .start:
                if state.isStart {
                    return .none
                }
                state.isStart = true
                let interval = state.interval
                state.progress = 0.0
                state.duration = 12.5
                return .run { send in
                    for await _ in clock.timer(interval: interval) {
                        await send(.update)
                        await send(.checkLoadedAD)
                    }
                }.cancellable(id: CancelID.timer)
            case .update:
                let isBackground = state.isBackground
                let interval = state.interval.inMilliseconds
                state.progress += interval  / state.duration
                if state.progress > 1.0 {
                    state.progress = 1.0
                    return .run { send in
                        await send(.stopLoading)
                        if isBackground {
                            await send(.dismiss)
                        } else {
                            await GADUtil.share.show(.interstitial)
                            await send(.dismiss)
                        }
                    }
                }
            case .checkLoadedAD:
                let progress = state.progress
                return .run{ send in
                    do {
                        let _ = try await GADUtil.share.load(.interstitial)
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
            case .appEnterbackground:
                state.isBackground = true
            case .appEnterforeground:
                state.isBackground = false
            default:
                break
            }
            return .none
        }
    }
}
