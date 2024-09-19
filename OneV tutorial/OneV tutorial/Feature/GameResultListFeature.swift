//
//  GameResultFeature.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/13.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GameResultListFeature {
    
    @ObservableState
    struct State: Equatable {
        var results: IdentifiedArrayOf<GameFeature.GameResult> = []
    }
  
    enum Action {
        
        case remove(offset: IndexSet)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .remove(offset: let offset):
                state.results.remove(atOffsets: offset)
                return .none
            }
        }
    }
}
