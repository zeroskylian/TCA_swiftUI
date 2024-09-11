//
//  CounterView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/11.
//


import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    
    @Bindable var store: StoreOf<CounterFeature>
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            checkLabel(with: store.checkResult)
            HStack {
                Button("-") { store.send(.decrement) }
                TextField(store.countString, text: $store.countString.sending(\.setCount)).frame(width: 40).multilineTextAlignment(.center)
                Button("+") { store.send(.increment)}
            }
            Button("PlayNext") { store.send(.playNext)}
        }
    }
    
    func colorOfText(_ count: Int) -> Color {
        return count >= 0 ? Color.green : Color.red
    }
    
    func checkLabel(with checkResult: CounterFeature.CheckResult) -> some View {
        switch checkResult {
        case .lower:
            return Label("Lower", systemImage: "lessthan.circle")
                .foregroundColor(.red)
        case .higher:
            return Label("Higher", systemImage: "greaterthan.circle")
                .foregroundColor(.red)
        case .equal:
            return Label("Correct", systemImage: "checkmark.circle")
                .foregroundColor(.green)
        }
    }
}
