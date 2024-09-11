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
        
        var secret = Int.random(in: -100 ... 100)
        
        var countString: String {
            get {
                return String(count)
            }
            set {
                if let count = Int(newValue) {
                    self.count = count
                }
            }
        }
        
        var checkResult: CheckResult {
            if count < secret { return .lower }
            if count > secret { return .higher }
            return .equal
        }
    }
    
    enum Action {
        case increment
        case decrement
        case setCount(String)
        case playNext
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
            case .playNext:
                state.count = 0
                state.secret = Int.random(in: -100 ... 100)
                return .none
            case .setCount(let countString):
                state.countString = countString
                return .none
            }
        }
    }
    
    enum CheckResult {
        case lower, equal, higher
    }
}

struct CounterEnvironment {
    var generateRandom: (ClosedRange<Int>) -> Int
    
    static let live = CounterEnvironment(generateRandom: Int.random(in:))
}

