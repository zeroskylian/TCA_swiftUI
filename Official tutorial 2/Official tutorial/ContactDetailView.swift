//
//  ContactDetailView.swift
//  Official tutorial
//
//  Created by lianxinbo on 2024/10/19.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
    
    @Bindable var store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        Form {
            Button("Delete") {
                store.send(.deleteButtonTapped)
            }
        }
        .navigationTitle(Text(store.contact.name))
        .alert($store.scope(state: \.alert, action: \.alert))
        
    }
}

