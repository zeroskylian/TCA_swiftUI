//
//  ContactsFeature.swift
//  Official tutorial
//
//  Created by lianxinbo on 2024/10/14.
//

import Foundation
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
    
    let id: UUID
    
    var name: String
}

@Reducer
struct ContactsFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var contacts: IdentifiedArrayOf<Contact> = [
            .init(id: UUID.init(0), name: "BB")
        ]
        
        @Presents var destination: Destination.State?
        
        var path = StackState<Path.State>()
    }
    
    enum Action {
        
        case addButtonTapped
        
        case deleteButtonTapped(id: Contact.ID)
        
        case destination(PresentationAction<Destination.Action>)
        
        case path(StackActionOf<Path>)
        
        case addButtonTappedStack
        
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<ContactsFeature> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: Contact(id: self.uuid(), name: "")
                    )
                )
                return .none
            case .deleteButtonTapped(id: let id):
                state.destination = .alert(.deleteConfirmation(id: id))
                return .none
            case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
                state.contacts.append(contact)
                return .none
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none
            case .destination:
                return .none
            case let .path(.element(id: _, action: .addItem(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                // 这行和 Presented在外部 dismiss 是一样的, 比较麻烦
                // state.path.pop(from: id)
                return .none
            case .addButtonTappedStack:
                state.path.append(.addItem(AddContactFeature.State(contact: Contact(id: self.uuid(), name: ""))))
                return .none
            case .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path)
    }
    
    @Dependency(\.uuid) var uuid
}


extension ContactsFeature {
    
    /// 拆分的原因是你的目标是在同一时段只能有一个弹窗, 但是之前的场景可能在同时弹出两个
    @Reducer
    enum Destination {
        
        case addContact(AddContactFeature)
        
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
    
    @Reducer
    enum Path {
        
        case addItem(AddContactFeature)
        
        case detailItem(ContactDetailFeature)
    }
    
}

extension ContactsFeature.Destination.State: Equatable {}

/// 这里别忘了, 给他增加 Equatable
extension ContactsFeature.Path.State: Equatable {}

extension AlertState where Action == ContactsFeature.Action.Alert {
    
    static func deleteConfirmation(id: UUID) -> Self {
        Self {
            TextState("Are you sure?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                TextState("Delete")
            }
        }
    }
}
