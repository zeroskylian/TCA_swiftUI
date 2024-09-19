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
        $0.game = .liveValue
    }
    
    var body: some View {
        NavigationStack {
            GameView(store: Self.store)
        }
    }
}
