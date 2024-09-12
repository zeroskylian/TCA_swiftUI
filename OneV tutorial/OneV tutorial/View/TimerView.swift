//
//  TimerView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/12.
//

import SwiftUI
import ComposableArchitecture

struct TimerView: View {
    
    let store: StoreOf<TimerFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            TimerLabelView(store: store)
            HStack {
                Button("Start") { store.send(.start) }
                Button("Stop") { store.send(.stop) }
            }.padding()
        }
    }
}

struct TimerLabelView: View {
    
    let store: StoreOf<TimerFeature>
    
    var body: some View {
        let _ = Self._printChanges()
        VStack(alignment: .leading) {
            Label(
                store.started == nil ? "-" : "\(store.started!.formatted(date: .omitted, time: .standard))",
                systemImage: "clock"
            )
            Label(
                "\(store.duration, format: .number)s",
                systemImage: "timer"
            )
        }
    }
}
