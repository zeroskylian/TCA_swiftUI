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
            ContactsView(store: Self.store)
//            ContentView()
        }
    }
}

/// 这里代码用于解释 ContactsFeature 中 addContact 为什么会自动变为 nil,
/// 系统的 sheet isPresented: 在 dismss 时会将关联值变为 false
/// 系统的 sheet item: Binding<Item?>  在 dismss 时会将关联值变为 nil
///  同理, ContactsFeature 使用的是 ComposableArchitecture 封装的 sheet, 也会将值变为 nil
struct DismissingView1: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Dismiss Me") {
            dismiss()
        }
    }
}

struct DismissingView2: View {
    
    @Binding var isPresented: Bool

    var body: some View {
        Button("Dismiss Me") {
            isPresented = false
        }
    }
}

struct ContentView: View {
    
    @State private var showingDetail = false

    var body: some View {
        VStack {
            Text("\(showingDetail)")
            Button("Show Detail") {
                showingDetail = true
            }
            .sheet(isPresented: $showingDetail) {
                DismissingView1()
//                DismissingView2(isPresented: $showingDetail)
            }
        }
    }
}

struct ContentView1: View {
    
    @State var value: PresentedValue?

    var body: some View {
        VStack {
            Text("\(value?.id ?? "Empty")")
            Button("Show Detail") {
                value = PresentedValue(id: "2")
            }
            .sheet(item: $value, content: { id in
                DismissingView1()
            })
        }
    }
}

struct PresentedValue: Identifiable {
    let id: String
}
