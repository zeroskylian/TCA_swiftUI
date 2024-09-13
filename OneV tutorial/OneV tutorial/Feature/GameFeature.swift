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

struct GameEnvironment: DependencyKey {
    
    static var liveValue: GameEnvironment = GameEnvironment(value: Int.random(in: -100 ... 100), date: Date.init, mainQueue: .main)
    
    static var testValue: GameEnvironment = GameEnvironment(value: 6, date: {
        return Date(timeIntervalSince1970: 100)
    }, mainQueue: .main)
    
    /// counter 用
    let value: Int
    
    /// timer 用
    var date: () -> Date
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension DependencyValues {
    
    var game: GameEnvironment {
        get { self[GameEnvironment.self] }
        set { self[GameEnvironment.self] = newValue }
    }
}

