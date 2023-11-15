//
//  TomatoBrowserApp.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/18.
//

import SwiftUI
import ComposableArchitecture
import FBSDKCoreKit
import IQKeyboardManagerSwift

@main
struct TomatoBrowserApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: Root.State(), reducer: {
                Root()
            }))
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(
                _ application: UIApplication,
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
            ) -> Bool {
                ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
                
                IQKeyboardManager.shared.enable = true
                IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
                IQKeyboardManager.shared.shouldResignOnTouchOutside = true
                IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
                
                GADUtil.share.requestConfig()

                return true
            }
                  
            func application(
                _ app: UIApplication,
                open url: URL,
                options: [UIApplication.OpenURLOptionsKey : Any] = [:]
            ) -> Bool {
                ApplicationDelegate.shared.application(
                    app,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                )
            }
    }
}
