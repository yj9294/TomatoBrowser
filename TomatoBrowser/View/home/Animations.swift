//
//  Animations.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct Animations: Reducer {
  struct State: Equatable {
    @PresentationState var alert: AlertState<Action.Alert>?
  }

  enum Action: Equatable, Sendable {
    case alert(PresentationAction<Alert>)
      case onAppear

    enum Alert: Equatable, Sendable {
    }
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.alert = AlertState {
          TextState("Reset state?")
        }
      default:
          break
      }
        return .none
    }.ifLet(\.$alert, action: /Action.alert)
  }
}

// MARK: - Feature view

struct AnimationsView: View {
  let store: StoreOf<Animations>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
        VStack{
            HStack{Spacer()}
            Spacer()
            Button {
                viewStore.send(.onAppear)
            } label: {
                Text("来点我")
            }
            Spacer()
        }.background.alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
    }
  }
}

// MARK: - SwiftUI previews

struct AnimationsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        AnimationsView(
          store: Store(initialState: Animations.State()) {
            Animations()
          }
        )
      }

      NavigationView {
        AnimationsView(
          store: Store(initialState: Animations.State()) {
            Animations()
          }
        )
      }
      .environment(\.colorScheme, .dark)
    }
  }
}
