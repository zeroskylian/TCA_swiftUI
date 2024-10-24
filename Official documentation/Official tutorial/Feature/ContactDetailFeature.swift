//
//  ContactDetailFeature.swift
//  Official tutorial
//
//  Created by lianxinbo on 2024/10/19.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ContactDetailFeature {
    
    @ObservableState
    struct State: Equatable {
        
        @Presents var alert: AlertState<Action.Alert>?
        
        let contact: Contact
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case deleteButtonTapped
        enum Alert {
            case confirmDeletion
        }
        enum Delegate {
            case confirmDeletion
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmDeletion)):
                return .run { send in
                    await send(.delegate(.confirmDeletion))
                    await self.dismiss()
                }
            case .alert:
                return .none
            case .delegate:
                return .none
            case .deleteButtonTapped:
                state.alert = .confirmDeletion
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
    
    @Dependency(\.dismiss) var dismiss
}

extension AlertState where Action == ContactDetailFeature.Action.Alert {
    
    static let confirmDeletion = Self {
        TextState("Are you sure?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmDeletion) {
            TextState("Delete")
        }
    }
}
