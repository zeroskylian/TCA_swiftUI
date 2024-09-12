//
//  ContentView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/11.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    static let counterStore = Store(initialState: CounterFeature.State(), reducer: {
        CounterFeature()
            ._printChanges()
    }) {
        $0.counterEnvironment = .live
    }
    
    static let timerStore = Store(initialState: TimerFeature.State(started: Date()), reducer: {
        TimerFeature()
            ._printChanges()
    }) {
        $0.timerEnvironment = .liveValue
    }
    
    var body: some View {
        VStack {
            TimerView(store: Self.timerStore)
            CounterView(store: Self.counterStore)
        }
    }
}
