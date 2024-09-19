//
//  GameView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/19.
//

import SwiftUI
import ComposableArchitecture

let resultListStateTag = UUID()

struct GameView: View {
    
    @Bindable var store: StoreOf<GameFeature>
    
    var body: some View {
        VStack {
            Text(String("Result: \(store.correctCount)/\(store.results.results.count) correct"))
            Divider()
            TimerView(store: store.scope(state: \.timer, action: \.timer))
            CounterView(store: store.scope(state: \.counter, action: \.counter))
        }
        .navigationTitle("Game")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Detail") {
                    store.send(.setNavigation)
                }
            }
        }
    }
}
