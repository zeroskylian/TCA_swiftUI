//
//  AddContactFeature.swift
//  Official tutorial
//
//  Created by lianxinbo on 2024/10/14.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddContactFeature {
    
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)
        
        /// 这里的目的是区分哪些需要父 Reducer响应的 Action, 哪些是自身的
        case delegate(Delegate)
        
        @CasePathable
        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { send in
                    await self.dismiss()
                }
            case .saveButtonTapped:
                return .run(operation: { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                })
            case .setName(let name):
                state.contact.name = name
                return .none
            case .delegate:
                return .none
            }
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
}
