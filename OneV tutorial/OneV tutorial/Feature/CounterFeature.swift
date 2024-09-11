//
//  CounterFeature.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/11.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        
        let name: String = "Counter"
        
        var count: Int = 0
    }
    
    enum Action {
        case increment
        case decrement
        case reset
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrement:
                state.count -= 1
                return .none
            case .increment:
                state.count += 1
                return .none
            case .reset:
                state.count = 0
                return .none
            }
        }
    }
}

struct CounterEnvironment {}

