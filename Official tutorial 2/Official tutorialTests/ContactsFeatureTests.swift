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
    
    /// 非详尽模式
    /// addFlow 测试非常详尽且强大, 但是太繁琐了, 我们必须断言子特征中的一切如何演变 ，并且必须断言商店如何接收每个效果操作
    /// 有时，以不太详尽的方式编写测试可能很有用，特别是在测试许多功能的集成时，例如执行导航的功能的情况。
    @Test
    func addFlowNonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        store.exhaustivity = .off
        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName, "Blob Jr.")
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.skipReceivedActions()
        store.assert {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
            $0.destination = nil
        }
    }
}
