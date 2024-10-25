//
//  ContactsView.swift
//  Official tutorial
//
//  Created by lianxinbo on 2024/10/14.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    
    @Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                Button("Add") {
                    // 这种方式是推荐的 使用 action 方式跳转
                    store.send(.addButtonTappedStack)
                }
                List {
                    ForEach(store.contacts) { contact in
                        // 这种方式是最基础的, 但是很麻烦 而且 不能模块化, 耦合很严重
                        NavigationLink(state: ContactsFeature.Path.State.detailItem(ContactDetailFeature.State(contact: contact))) {
                            HStack {
                                Text(contact.name)
                                Spacer()
                                Button {
                                    store.send(.deleteButtonTapped(id: contact.id))
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        } destination: { store in
            switch store.case {
            case .addItem(let store):
                AddContactView(store: store)
            case .detailItem(let store):
                ContactDetailView(store: store)
            }
        }
        .sheet(
            item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact)
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}
