//
//  ShareView.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct Share: Reducer {
    struct State: Equatable {}
    enum Action: Equatable {
        case dismiss
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            return .none
        }
    }
}

struct ShareViwe: UIViewControllerRepresentable {
    let store: StoreOf<Share>
    let url: String
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil)
        vc.completionWithItemsHandler = context.coordinator.handle
        return vc
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ShareViwe
        var handle: UIActivityViewController.CompletionWithItemsHandler? = nil
        init(_ parent: ShareViwe) {
            self.parent = parent
            self.handle = { _,_,_,_ in
                parent.store.send(.dismiss)
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
