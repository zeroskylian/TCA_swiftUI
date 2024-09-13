//
//  ContentView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/11.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    static let store = Store(initialState: GameFeature.State(), reducer: {
        GameFeature()
            ._printChanges()
    }) {
        $0.counterEnvironment = .live
        $0.timerEnvironment = .liveValue
    }
    
    var body: some View {
        VStack {
            TimerView(store: Self.store.scope(state: \.timer, action: \.timer))
            CounterView(store: Self.store.scope(state: \.counter, action: \.counter))
        }
    }
}
