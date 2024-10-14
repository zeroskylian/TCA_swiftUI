//
//  AppFeatureTests.swift
//  Official tutorialTests
//
//  Created by lianxinbo on 2024/10/14.
//

import ComposableArchitecture
import Testing

@testable import Official_tutorial

@MainActor
struct AppFeatureTests {
  @Test
  func incrementInFirstTab() async {
    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    }
    
    await store.send(\.tab1.incrementButtonTapped) {
      $0.tab1.count = 1
    }
  }
}
