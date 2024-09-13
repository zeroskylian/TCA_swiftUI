//
//  GameResultFeature.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/13.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GameResultFeature {
    
    @ObservableState
    struct State: Equatable {
        var results: [GameResult] = []
    }
    
    enum Action {
       case addResult(GameResult)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addResult(let result):
                state.results.append(result)
                return .none
            }
        }
    }
}


extension GameResultFeature {
    
    struct GameResult: Equatable {
      let secret: Int
      let guess: Int
      let timeSpent: TimeInterval
    }
}
