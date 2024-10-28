//
//  SyncUpsListTests.swift
//  Official_SyncUps_tutorialTests
//
//  Created by lianxinbo on 2024/10/28.
//

import ComposableArchitecture
import Testing

@testable import Official_SyncUps_tutorial

@MainActor
struct SyncUpsListTests {
    
    @Test
    func deletion() async {
        
        let store = TestStore(
            initialState: SyncUpsList.State(
                syncUps: [
                    SyncUp(
                        id: SyncUp.ID(),
                        title: "Point-Free Morning Sync"
                    )
                ]
            )
        ) {
            SyncUpsList()
        }
        
        await store.send(.onDelete([0])) { state in
            state.syncUps = []
        }
    }
}
