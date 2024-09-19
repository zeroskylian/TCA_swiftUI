//
//  GameView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/19.
//

import SwiftUI
import ComposableArchitecture

struct GameView: View {
    
    let store: StoreOf<GameFeature>
    
    var body: some View {
        VStack {
            Text(String("Result: \(store.correctCount)/\(store.results.results.count) correct"))
            Divider()
            TimerView(store: store.scope(state: \.timer, action: \.timer))
            CounterView(store: store.scope(state: \.counter, action: \.counter))
        }
    }
}
