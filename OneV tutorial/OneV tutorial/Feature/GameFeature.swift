//
//  GameFeature.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/13.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GameFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var counter: CounterFeature.State = .init()
        
        var timer: TimerFeature.State = .init()
    }
    
    enum Action {
        
        case counter(CounterFeature.Action)
        
        case timer(TimerFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.counter, action: \.counter) {
            CounterFeature()
        }
        
        Scope(state: \.timer, action: \.timer) {
            TimerFeature()
        }
        Reduce { state, action in
            return .none
        }
    }
}

struct GameEnvironment {}
