//
//  GameResultListView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/19.
//

import SwiftUI
import ComposableArchitecture

struct GameResultListView: View {
    
    let store: StoreOf<GameResultListFeature>
    
    var body: some View {
        List {
            ForEach(store.results) { result in
                HStack {
                    Image(systemName: result.correct ? "checkmark.circle" : "x.circle")
                    Text("Secret: \(result.counter.secret)")
                    Text("Answer: \(result.counter.count)")
                }.foregroundColor(result.correct ? .green : .red)
            }.onDelete {
                store.send(.remove(offset: $0))
            }
        }
    }
}
