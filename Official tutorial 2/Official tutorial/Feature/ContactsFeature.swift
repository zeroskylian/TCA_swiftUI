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
        
        var contacts: IdentifiedArrayOf<Contact> = []
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        
        case addButtonTapped
        
        case deleteButtonTapped(id: Contact.ID)
        
        case destination(PresentationAction<Destination.Action>)
        
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
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
            case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
                state.contacts.append(contact)
                return .none
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none
            case .destination:
                return .none
            }
        }.ifLet(\.$destination, action: \.destination)
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
