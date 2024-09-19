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
        
        var results: GameResultListFeature.State = .init()
        
        var lastTimestamp = 0.0
        
        var correctCount: Int {
            return results.results.filter(\.correct).count
        }
    }
    
    enum Action {
        
        case counter(CounterFeature.Action)
        
        case timer(TimerFeature.Action)
        
        case listResult(GameResultListFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .counter(.playNext):
                let result = GameResult(counter: state.counter, timeSpent: state.timer.duration - state.lastTimestamp)
                state.results.results.append(result)
                state.lastTimestamp = state.timer.duration
                return .none
            default:
                return .none
            }
        }
        Scope(state: \.counter, action: \.counter) {
            CounterFeature()
        }
        
        Scope(state: \.timer, action: \.timer) {
            TimerFeature()
        }
        
        Scope(state: \.results, action: \.listResult) {
            GameResultListFeature()
        }
    }
}

extension GameFeature {
    
    struct GameResult: Equatable, Identifiable {
        
        let counter: CounterFeature.State
        
        let timeSpent: TimeInterval
        
        var correct: Bool {
            return counter.secret == counter.count
        }
        
        var id: UUID { counter.id }
    }
}

struct GameEnvironment: DependencyKey {
    
    static var liveValue: GameEnvironment = GameEnvironment(value: Int.random(in: -100 ... 100), uuid: UUID.init, date: Date.init, mainQueue: .main)
    
    static var testValue: GameEnvironment = GameEnvironment(value: 6, uuid: UUID.init, date: {
        return Date(timeIntervalSince1970: 100)
    }, mainQueue: .main)
    
    /// counter 用
    let value: Int
    
    /// 生成 UUID
    let uuid: () -> UUID
    
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

