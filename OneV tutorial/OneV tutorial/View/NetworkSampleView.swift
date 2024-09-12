//
//  NetworkSampleView.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/12.
//

import SwiftUI
import ComposableArchitecture

struct NetworkSampleView: View {
    
    let store: StoreOf<NetworkSampleFeature>
    
    var body: some View {
        ZStack {
            VStack {
                Button("Load") { store.send(.load) }
                Text(store.text)
            }
            if store.loading {
                ProgressView().progressViewStyle(.circular)
            }
        }
    }
}

