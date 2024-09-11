//
//  ContentView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/11.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some View {
        VStack {
            CounterView(store: Self.store)
        }
    }
}
