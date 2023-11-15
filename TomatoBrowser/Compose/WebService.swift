//
//  WebService.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/20.
//

import Foundation
import WebKit
import SwiftUI
import Combine
import ComposableArchitecture

class WebService: NSObject {
    var browserView: WKWebView = .init()
    var cancellables: Set<AnyCancellable> = []
    var progress: AsyncStream<Double> {
        AsyncStream { continuation in
            Task.detached { @MainActor in
                self.browserView.publisher(for: \.estimatedProgress).sink { value in
                    continuation.yield(value)
                }.store(in: &self.cancellables)
            }
        }
    }
    var canGoBack: AsyncStream<Bool> {
        AsyncStream { continuation in
            Task.detached { @MainActor in
                self.browserView.publisher(for: \.canGoBack).sink { value in
                    continuation.yield(value)
                }.store(in: &self.cancellables)
            }
        }
    }
    var canGoForward: AsyncStream<Bool> {
        AsyncStream { continuation in
            Task.detached { @MainActor in
                self.browserView.publisher(for: \.canGoForward).sink { value in
                    continuation.yield(value)
                }.store(in: &self.cancellables)
            }
        }
    }
    var isLoading: AsyncStream<Bool> {
        AsyncStream { continuation in
            Task.detached { @MainActor in
                self.browserView.publisher(for: \.isLoading).sink { value in
                    continuation.yield(value)
                }.store(in: &self.cancellables)
            }
        }
    }
    var url: AsyncStream<String> {
        AsyncStream { continuation in
            Task.detached { @MainActor in
                self.browserView.publisher(for: \.url).compactMap{$0?.absoluteString}.sink { value in
                    continuation.yield(value)
                }.store(in: &self.cancellables)
            }
        }
    }
    var isBrowser: AsyncStream<Bool> {
        AsyncStream { continuation in
            Task.detached { @MainActor in
                self.browserView.publisher(for: \.url).compactMap{$0?.absoluteString}.sink { value in
                    continuation.yield(!value.isEmpty)
                }.store(in: &self.cancellables)
            }
        }
    }
}

extension DependencyValues {
  var webService: WebService {
    get { self[WebService.self] }
    set { self[WebService.self] = newValue }
  }
}

extension WebService: DependencyKey {
    static let previewValue = WebService()
    static let liveValue = WebService()
}
