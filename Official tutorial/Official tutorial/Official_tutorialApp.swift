//
//  Official_tutorialApp.swift
//  Official tutorial
//
//  Created by lianxinbo on 2024/9/11.
//

import SwiftUI
import ComposableArchitecture

@main
struct Official_tutorialApp: App {
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                CounterView(store: Self.store.scope(state: \.tab1, action: \.tab1)).tabItem {
                    Text("Counter 1")
                }
                CounterView(store: Self.store.scope(state: \.tab2, action: \.tab2)).tabItem {
                    Text("Counter 2")
                }
            }
           
        }
    }
}
