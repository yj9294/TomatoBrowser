//
//  LaunchReducer.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/18.
//

import SwiftUI
import ComposableArchitecture
import UniformTypeIdentifiers
import AppTrackingTransparency

struct Home: Reducer {
    struct State: Equatable {
        var search: HomeSearch.State = .init()
        var content: HomeContent.State = .init()
        var tabbar: HomeTabbar.State = .init()
        
        @PresentationState var list: BrowserList.State?
        @PresentationState var setting: Setting.State?
        @PresentationState var share: Share.State?
        @PresentationState var privacy: Privacy.State?
        @PresentationState var cleanAlert: CleanAlert.State?
        @PresentationState var clean: Clean.State?
        @PresentationState var alert: AlertState<Action.Alert>?

        var items: StackState<HomeContent.State>
        var item: HomeContent.State {
            items.filter {
                $0.isSelected
            }.first ?? .init()
        }
    }
    enum Action: Equatable {

        case search(HomeSearch.Action)
        case content(HomeContent.Action)
        case tabbar(HomeTabbar.Action)
        
        case list(PresentationAction<BrowserList.Action>)
        case setting(PresentationAction<Setting.Action>)
        case share(PresentationAction<Share.Action>)
        case privacy(PresentationAction<Privacy.Action>)
        case cleanAlert(PresentationAction<CleanAlert.Action>)
        case clean(PresentationAction<Clean.Action>)
        
        case refresh
        
        case alert(PresentationAction<Alert>)
        
        case alertMessage(Alert)
        enum Alert: Equatable, Sendable {
            case clean, copy, search
        }
        case present(Present)
        case dismiss(Present)
        enum Present: Equatable, Sendable {
            case list, setting, share, privacy(Privacy.State.Item = .privacy), cleanAlert, clean
        }
        
        case att
        case loadingAD(GADShowPosition = .home)
        case cleanAD

    }
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .search(action):
                switch action {
                case .search:
                    state.content.url = state.search.text
                    if state.content.url.isEmpty {
                        return .run { send in
                            await send(.alertMessage(.search))
                        }
                    }
                    NotificationCenter.default.post(name: .search, object: nil)
                case .stop:
                    NotificationCenter.default.post(name: .stop, object: nil)
                default:
                    break
                }
            case let .content(contentAction):
                switch contentAction {
                case let .url(url):
                    state.search.text = url
                case let .progress(progress):
                    state.search.isLoading = progress != 1.0
                case let .canGoBack(ret):
                    state.tabbar.canGoBack = ret
                case let .canGoForward(ret):
                    state.tabbar.canGoForward = ret
                default:
                    break
                }
            case let .tabbar(tabbarAction):
                switch tabbarAction {
                case let .tabbarButtonTapped(action):
                    switch action {
                    case .left:
                        state.content.browserView.goBack()
                    case .right:
                        state.content.browserView.goForward()
                    case .tab:
                        return .run { send in
                            await send(.cleanAD)
                            await send(.present(.list))
                            await send(.loadingAD(.list))
                        }
                    case .settings:
                        return .run { send in
                            await send(.present(.setting))
                        }
                    case .clean:
                        return .run { send in
                            await send(.present(.cleanAlert))
                        }
                    }
                }
                
            case let .list(.presented(action)):
                switch action{
                case .back:
                    return .run { send in
                        await send(.dismiss(.list))
                        await send(.cleanAD)
                        await send(.loadingAD())
                    }
                case .add:
                    state.items = unSelected(in: state.items)
                    state.items.insert(.init(), at: 0)
                    
                    return .run { send in
                        await send(.refresh)
                        await send(.dismiss(.list))
                        await send(.loadingAD())
                    }
                case let .content(action):
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
                                state.content = state.item
                            }
                        }
                        
                        return .run { send in
                            await send(.refresh)
                        }
                    case let .itemButtonTapped(item):
                        state.items = unSelected(in: state.items)
                        state.items = selected(item, in: state.items)
                        
                        return .run { send in
                            await send(.refresh)
                            await send(.dismiss(.list))
                            await send(.loadingAD())
                        }
                    default:
                        break
                    }
                default:
                    break
                }
            case let .setting(.presented(action)):
                switch action {
                case .dismiss:
                    return .run { send in
                        await send(.dismiss(.setting))
                    }
                case .add:
                    state.items = unSelected(in: state.items)
                    state.items.insert(.init(), at: 0)
                    
                    return .run { send in
                        await send(.dismiss(.setting))
                        await send(.refresh)
                    }
                case .share:
                    return .run{ send in
                        await send(.dismiss(.setting))
                        await send(.present(.share))
                    }
                case .copy:
                    UIPasteboard.general.setValue(state.search.text, forPasteboardType: UTType.plainText.identifier)
                    return .run { send in
                        await send(.dismiss(.setting))
                        await send(.alertMessage(.copy))
                    }
                case .rate:
                    let AppUrl = "https://itunes.apple.com/cn/app/id6471950350"
                    OpenURLAction { URL in
                        .systemAction(URL)
                    }.callAsFunction(URL(string: AppUrl)!)
                    return .run { send in
                        await send(.dismiss(.setting))
                    }
                case .privacy:
                    state.setting = nil
                    return .run { send in
                        await send(.cleanAD)
                        await send(.present(.privacy(.privacy)))
                    }
                case .terms:
                    state.setting = nil
                    return .run { send in
                        await send(.cleanAD)
                        await send(.present(.privacy(.terms)))
                    }
                }
            case let .share(action):
                if action == .dismiss {
                    return .run { send in
                        await send(.dismiss(.share))
                    }
                }
            case let .privacy(.presented(action)):
                if action == .dismiss {
                    return .run { send in
                        await send(.dismiss(.privacy()))
                        await send(.loadingAD())
                    }
                }
            case let .cleanAlert(.presented(action)):
                switch action {
                case .dismiss:
                    return .run { send in
                        await send(.dismiss(.cleanAlert))
                    }
                case .confirm:
                    return .run{ send in
                        await send(.dismiss(.cleanAlert))
                        await send(.cleanAD)
                        await send(.present(.clean))
                    }
                }
            case let .clean(.presented(action)):
                switch action {
                case .dismiss:
                    state.items = StackState([.init()])
                    return .run { send in
                        await send(.dismiss(.clean))
                        await send(.refresh)
                        await send(.alertMessage(.clean))
                        await send(.loadingAD())
                    }
                default:
                    break
                }
            case .refresh:
                state.content = state.item
                state.search.text = state.item.url
                state.search.isLoading = state.item.isLoading
                state.tabbar.canGoBack = state.item.canGoBack
                state.tabbar.canGoForward = state.item.canGoForward
                state.tabbar.count = state.items.count
            case let .alertMessage(action):
                switch action {
                case .clean:
                    state.alert = AlertState {
                        TextState(verbatim: .cleanSuccess)
                    }
                case .copy:
                    state.alert = AlertState {
                        TextState(verbatim: .copySuccess)
                    }
                case .search:
                    state.alert = AlertState {
                        TextState(verbatim: .searchFailed)
                    }
                }
            case .att:
                ATTrackingManager.requestTrackingAuthorization { _ in
                }
            case let .present(action):
                switch action {
                case let .privacy(action):
                    switch action {
                    case .privacy:
                        state.privacy = .init()
                    case .terms:
                        state.privacy = .init(item: .terms)
                    }
                case .clean:
                    state.clean = .init()
                case .cleanAlert:
                    state.cleanAlert = .init()
                case .setting:
                    state.setting = .init()
                case .share:
                    state.share = .init()
                case .list:
                    let newItems = state.items.compactMap({
                        if $0.isSelected {
                            return state.content
                        }
                        return $0
                    })
                    state.items = StackState(newItems)
                    state.list = .init(content: BrowserListContent.State(items: StackState(newItems)))
                }
            case let .dismiss(action):
                switch action {
                case .privacy(_):
                    state.privacy = nil
                case .clean:
                    state.clean = nil
                case .cleanAlert:
                    state.cleanAlert = nil
                case .setting:
                    state.setting = nil
                case .share:
                    state.share = nil
                case .list:
                    state.list = nil
                }
            default:
                break
            }
            return .none
        }.ifLet(\.$list, action: /Action.list) {
            BrowserList()
        }.ifLet(\.$setting, action: /Action.setting) {
            Setting()
        }.ifLet(\.$cleanAlert, action: /Action.cleanAlert) {
            CleanAlert()
        }.ifLet(\.$clean, action: /Action.clean) {
            Clean()
        }.ifLet(\.$alert, action: /Action.alert)

        Scope.init(state: \.search, action: /Action.search) {
            HomeSearch()
        }
        Scope.init(state: \.content, action: /Action.content) {
            HomeContent()
        }
        Scope.init(state: \.tabbar, action: /Action.tabbar) {
            HomeTabbar()
        }
    }
}

func unSelected(in items: StackState<HomeContent.State>) -> StackState<HomeContent.State> {
    let newItems = items.map {
        var ele = $0
        if $0.isSelected {
            ele.isSelected = false
        }
        return ele
    }
    return StackState(newItems)
}

func selected(_ item:HomeContent.State, in items: StackState<HomeContent.State>) -> StackState<HomeContent.State> {
    let newItems = items.map {
        var ele = $0
        if $0 == item {
            ele.isSelected = true
        }
        return ele
    }
    return StackState(newItems)
}

func refreshAD(_ ad: GADNativeViewModel , in items: StackState<HomeContent.State>) -> StackState<HomeContent.State> {
    let newItems = items.map {
        var ele = $0
        if $0.isSelected {
            ele.ad = ad
        }
        return ele
    }
    return StackState(newItems)
}
