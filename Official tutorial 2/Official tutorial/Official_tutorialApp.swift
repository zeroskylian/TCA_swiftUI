//
//  Official_tutorialApp.swift
//  Official tutorial
//
//  Created by lianxinbo on 2024/9/11.
//

import SwiftUI
import ComposableArchitecture

@main
struct Official_tutorialApp: App {
    
    static let store = Store(initialState: ContactsFeature.State()) {
        ContactsFeature()._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            
        }
    }
}
