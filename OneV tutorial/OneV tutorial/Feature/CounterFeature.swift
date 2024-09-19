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
    struct State: Equatable, Identifiable {
        
        var id: UUID = UUID()
        
        let name: String = "Counter"
        
        var count: Int = 0
        
        var secret = CounterEnvironment.live.value
        
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
        
        var doubleValue: Double {
            get {
                return Double(count)
            }
            set {
                count = Int(newValue)
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
        case setDouble(Double)
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
                state.secret = self.randomValue
                state.id = self.uuid()
                return .none
            case .setCount(let countString):
                state.countString = countString
                return .none
            case .setDouble(let value):
                state.doubleValue = value
                return .none
            }
        }
    }
    
    @Dependency(\.game.value) var randomValue
    @Dependency(\.game.uuid) var uuid
}

extension CounterFeature {
    
    enum CheckResult {
        case lower, equal, higher
    }
}

struct CounterEnvironment: DependencyKey {
    
    static let liveValue = Self.init(value: Int.random(in: -100 ... 100))
    
    let value: Int
    
    static let live = CounterEnvironment(value: Int.random(in: -100 ... 100))
    
    static let testValue: CounterEnvironment = CounterEnvironment(value: 5)
}

extension DependencyValues {
    
    var counterEnvironment: CounterEnvironment {
        get { self[CounterEnvironment.self] }
        set { self[CounterEnvironment.self] = newValue }
    }
}
