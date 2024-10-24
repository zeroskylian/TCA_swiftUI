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
        
        var path = StackState<ContactDetailFeature.State>()
        
    }
    
    enum Action {
        
        case addButtonTapped
        
        case deleteButtonTapped(id: Contact.ID)
        
        case destination(PresentationAction<Destination.Action>)
        
        case path(StackAction<ContactDetailFeature.State, ContactDetailFeature.Action>)
        
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
            case let .path(.element(id: id, action: .delegate(.confirmDeletion))):
                guard let detailState = state.path[id: id] else { return .none }
                state.contacts.remove(id: detailState.contact.id)
                return .none
            case .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path) {
            ContactDetailFeature()
        }
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
}

extension ContactsFeature.Destination.State: Equatable {}

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
