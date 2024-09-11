//
//  OneV_tutorialTests.swift
//  OneV tutorialTests
//
//  Created by lianxinbo on 2024/9/11.
//

import XCTest
@testable import OneV_tutorial
import ComposableArchitecture

final class OneV_tutorialTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCounter() async  {
        let store = await TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.increment) { state in
            state.count += 1
        }
        
        await store.send(.decrement) { state in
            state.count -= 1
        }
        
        await store.send(.playNext)
    }
    
    func testPlayNext() async {
        let store = await TestStore(initialState: CounterFeature.State(secret: CounterEnvironment.test.value), reducer: {
            CounterFeature()
        }) {
            $0.counterEnvironment = .test
        }
        
        /**
         failed - State was not expected to change, but a change occurred: …

               CounterFeature.State(
                 name: "Counter",
                 _count: 0,
             −   _secret: 22
             +   _secret: 5
               )

         (Expected: −, Actual: +)
         */
        
        /**
         因为 .playNext 现在不仅重置 count，也会随机生成新的 secret。而 TestStore 会把 send 闭包结束时的 state 和真正的由 reducer 操作的 state 进行比较并断言：前者没有设置合适的 secret，导致它们并不相等，所以测试失败了。
         */
        await store.send(.playNext)
    }
    
    func testSlider() async {
        let store = await TestStore(initialState: CounterFeature.State(secret: CounterEnvironment.test.value), reducer: {
            CounterFeature()
        }) {
            $0.counterEnvironment = .test
        }
        
        await store.send(.setDouble(4.2)) {
            $0.count = 4
        }
    }
}
