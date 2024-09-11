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
        let _ = Self._printChanges()
        VStack {
            HStack {
                Button("-") { store.send(.decrement) }
                Text(String(store.count)).foregroundStyle(colorOfText(store.count))
                Button("+") { store.send(.increment)}
            }
            
            Button("Reset") { store.send(.reset)}
        }
    }
    
    func colorOfText(_ count: Int) -> Color {
        return count >= 0 ? Color.green : Color.red
    }
}
