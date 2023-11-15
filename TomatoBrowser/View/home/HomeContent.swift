//
//  HomeContentReducer.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/19.
//

import Foundation
import WebKit
import Combine
import ComposableArchitecture


struct HomeContent: Reducer {
    
    struct State: Equatable, Hashable, Identifiable {
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id &&
            lhs.progress == rhs.progress &&
            lhs.ad == rhs.ad
        }
        var id: String = UUID().uuidString
        var items: [Item] = Item.allCases
        var browserView: WKWebView = .init()
        var isSelected = true
        
        var isBrowser = false
        var progress = 0.0
        var canGoBack = false
        var canGoForward = false
        var url = ""
        
        var ad: GADNativeViewModel = .none
    }
    enum Action: Equatable {
        case itemButtonTapped(State.Item)
        
        case progress(Double)
        case url(String)
        case canGoBack(Bool)
        case canGoForward(Bool)
        case isBrowser(Bool)
        case search
        
        case searchButtonTapped
        case stopButtonTapped
        
        case ad(GADNativeViewModel)
        
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            switch action {
            case .search:
                if let url = URL(string: state.url) {
                    state.browserView.load(URLRequest(url: url))
                }
                let progress = state.browserView.publisher(for: \.estimatedProgress).map{Action.progress($0)}
                let url = state.browserView.publisher(for: \.url).compactMap({$0?.absoluteString}).map{Action.url($0)}
                let canGoBack = state.browserView.publisher(for: \.canGoBack).map{Action.canGoBack($0)}
                let canGoForward = state.browserView.publisher(for: \.canGoForward).map{Action.canGoForward($0)}
                let isBrowser = state.browserView.publisher(for: \.url).compactMap({$0?.absoluteString}).map({!$0.isEmpty}).map{Action.isBrowser($0)}
                let publisher = progress.merge(with: url).merge(with: canGoBack).merge(with: canGoForward).merge(with: isBrowser) .eraseToAnyPublisher()
                return .publisher {
                    publisher
                }
            case let .itemButtonTapped(item):
                state.isBrowser = true
                state.url = item.url
                return .run { send in
                    await send(.search)
                }
            case let .progress(progress):
                debugPrint("当前进度\(progress) \(state.url)")
                state.progress = progress
            case let .url(url):
                state.url = url
            case let .canGoBack(ret):
                state.canGoBack = ret
            case let .canGoForward(ret):
                state.canGoForward = ret
            case let .isBrowser(ret):
                state.isBrowser = ret
            case .searchButtonTapped:
                if state.url.isUrl, let _ = URL(string: state.url) {
                } else {
                    let urlString = state.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    state.url = "https://www.google.com/search?q=" + urlString
                }
                return .run { send in
                    await send(.search)
                }
            case .stopButtonTapped:
                state.browserView.stopLoading()
            case let .ad(ad):
                state.ad = ad

            }
            return .none
        }
    }
}

extension HomeContent.State {
    var isLoading: Bool {
        progress >= 0.1 && progress < 1.0
    }
    enum Item: String, CaseIterable {
        case facebook,google, youtube, twitter, instagram, amazon, gmail, yahoo
        var icon: String {
            "home_\(self.rawValue)"
        }
        var title: String {
            self.rawValue.capitalized
        }
        var url: String {
            "https://www.\(self.rawValue).com"
        }
    }
}


extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}
