# Environment

Environment 已废弃, 替代的是 Dependency, 代码实现如下:

1. 定义 DependencyValues

```swift
struct CounterEnvironment: DependencyKey {

    static let liveValue = Self.init(value: Int.random(in: -100 ... 100))

    let value: Int

    static let live = CounterEnvironment(value: Int.random(in: -100 ... 100))

    static let test = CounterEnvironment(value: 5)
}

extension DependencyValues {

    var counterEnvironment: CounterEnvironment {
        get { self[CounterEnvironment.self] }
        set { self[CounterEnvironment.self] = newValue }
    }
}
```

2. 获取值

```swift

@Reducer
struct CounterFeature {

    // 省略代码

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrement:
                state.count -= 1
                return .none
            case .increment:
                state.count += 1
                return .none
            case .playNext:
                state.count = 0
                // 使用
                state.secret = self.randomValue.value
                return .none
            case .setCount(let countString):
                state.countString = countString
                return .none
            }
        }
    }

    @Dependency(\.counterEnvironment) var randomValue
}

```

3. 依赖注入
   在定义 store 时

```swift
static let store = Store(initialState: CounterFeature.State(), reducer: {
    CounterFeature()._printChanges()
}) {
    $0.counterEnvironment = .live
}
```
