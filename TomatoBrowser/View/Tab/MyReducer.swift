//
//  MyReducer.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/27.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct BaseView<T: Reducer> {
    let store: StoreOf<T>
}
