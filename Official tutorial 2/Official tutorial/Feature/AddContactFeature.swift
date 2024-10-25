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
                    // 注意这里要是有其他操作一定要在 dismiss 之前执行
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
    
    /// 这里的 dismiss 有两种模式
    /// 如果你是通过 present 出来的他可以将  @Presents 置为空
    /// 如果你是通过 Stack 出来的, 他可以将堆栈从 StackState 移除 它会向系统发送 StackAction.popFrom(id:) 操作，导致功能状态被移除
    @Dependency(\.dismiss) var dismiss
    
}
