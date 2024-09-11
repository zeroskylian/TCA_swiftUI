//
//  CounterView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/11.
//


import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        HStack {
            Button("-") { store.send(.decrement) }
            let _ = Self._printChanges()
            Text(String(store.count))
            Button("+") { store.send(.increment)}
        }
    }
}
