//
//  AppFeatureTests.swift
//  Official tutorialTests
//
//  Created by lianxinbo on 2024/10/14.
//

import ComposableArchitecture
import Testing
import Foundation
import CasePaths

@testable import Official_tutorial

@MainActor
struct ContactsFeatureTests {
    
    @Test
    func addFlow() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addButtonTapped) { state in
            state.destination = .addContact(
                AddContactFeature.State(
                    contact: Contact(id: UUID(0), name: "")
                )
            )
        }
        
        await store.send(\.destination.addContact.setName, "Blob Jr.") { state in
            state.destination?.modify(\.addContact, yield: {
                $0.contact.name = "Blob Jr."
            })
        }
        
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.receive(
            \.destination.addContact.delegate.saveContact,
             Contact(id: UUID(0), name: "Blob Jr.")
        ) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
        }
        
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
}
