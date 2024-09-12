//
//  TimerFeature.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/12.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TimerFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var started: Date?
        
        var duration: TimeInterval = 0
    }
    
    enum Action {
        case start
        case stop
        case timeUpdated
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .start:
                if state.started == nil {
                    state.started = timer.date()
                }
                return .publisher {
                    return mainQueue.timerPublisher(every: .milliseconds(100)).autoconnect().map { publish in
                        return Action.timeUpdated
                    }
                }.cancellable(id: TimerId())
            case .timeUpdated:
                state.duration += 0.01
                return .none
            case .stop:
                return .cancel(id: TimerId())
            }
        }
    }
    
    @Dependency(\.timerEnvironment) var timer
    
    @Dependency(\.continuousClock) var clock
    
    @Dependency(\.mainQueue) var mainQueue
    
    struct TimerId: Hashable {}
}

struct TimerEnvironment: DependencyKey {
    
    static var liveValue: TimerEnvironment {
        return .init(date: Date.init, mainQueue: .main)
    }
    
    static var test: TimerEnvironment {
        return .init(date: {
            return Date(timeIntervalSince1970: 100)
        }, mainQueue: .main)
    }
     
    var date: () -> Date
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension DependencyValues {
    
    var timerEnvironment: TimerEnvironment {
        get { self[TimerEnvironment.self] }
        set { self[TimerEnvironment.self] = newValue }
    }
}

