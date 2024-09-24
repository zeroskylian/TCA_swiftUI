//
//  CounterFeatureTests.swift
//  Official tutorialTests
//
//  Created by lianxinbo on 2024/9/24.
//

import XCTest
@testable import Official_tutorial
import ComposableArchitecture

final class CounterFeatureTests: XCTestCase {
    
    /**
     这里会编译错误不知道为什么会报错
     https://github.com/pointfreeco/swift-composable-architecture/discussions/3292
     官方的解释是 build configuration最好只有 Debug 和 Release 两个命名
     我的解决办法是:
     方法 1: clean project 删除掉SPM, 重新添加 ComposableArchitecture, clean project 不管用就下一条
     方法 2: 点击项目文件 -> project, 切换 build run profile... 的 build configuration , debug release 来回切换 不管用就下一条
     方法 3: 进入 ~/Library/org.swift.swiftpm/security/macros.json, 删除掉信任的宏
     */
    
    func testCounter() async {
        let store = await TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        await store.send(.incrementButtonTapped) { state in
            state.count = 1
        }
        await store.send(.decrementButtonTapped) { state in
            state.count = 0
        }
    }
    
    func testTimer() async {
        let store = await TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }

        // TCA 在对应 Effect 测试时，会对还未被 receive 的 action 以及还在运行的 Effect 进行断言
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        await store.receive(\.timerTick, timeout: .seconds(2)) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
}

