# Effect.Timer

[已废弃](<https://pointfreeco.github.io/swift-composable-architecture/0.42.0/documentation/composablearchitecture/effect/timer(id:every:tolerance:on:options:)-4exe6/>), 可以使用 Combine 或者 publisher

## continuousClock + Concurrency

```swift
@Dependency(\.continuousClock) var clock

return .run { send in
    for await _ in self.clock.timer(interval: .seconds(0.1)) {
        await send(.timeUpdated)
    }
}.cancellable(id: TimerId())
```

## Combine

```swift

@Dependency(\.mainQueue) var mainQueue
// @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
return .publisher {
    mainQueue.timerPublisher(every: .milliseconds(100)).autoconnect().map { _ in
        Action.timeUpdated
    }
}.cancellable(id: TimerId())
```

# eraseToEffect

[已废弃](<https://pointfreeco.github.io/swift-composable-architecture/0.42.0/documentation/composablearchitecture/effect/erasetoeffect()/>), 替换方法:

```swift

var body: some Reducer<State, Action> {
    Reduce { state, action in
        switch action {
        case .load:
            return .run { send in
                let result = await networkSample.loadText()
                await send(.loaded(result))
            }
            ...
        }
    }
}

struct NetworkSampleFeatureEnvironment: DependencyKey {

    var loadText: () async -> Result<String, URLError>

    var mainQueue: AnySchedulerOf<DispatchQueue>

    static let liveValue: NetworkSampleFeatureEnvironment = NetworkSampleFeatureEnvironment(
        loadText: {
            do {
                let (data, response) = try await URLSession.shared
                    .data(from: URL(string: "http://numbersapi.com/")!)
                guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else {
                    return .failure(URLError(.badServerResponse))
                }
                let fact = String(decoding: data, as: UTF8.self)
                return .success(fact)
            } catch {
                return .failure(URLError(.badServerResponse))
            }
        },
        mainQueue: .main
    )
}
```

# pullback

[已废弃](<https://pointfreeco.github.io/swift-composable-architecture/0.42.0/documentation/composablearchitecture/anyreducer/pullback(state:action:environment:)>), 使用 Scope 代替

```swift
var body: some Reducer<State, Action> {
    Scope(state: \.counter, action: \.counter) {
        CounterFeature()
    }

    Scope(state: \.timer, action: \.timer) {
        TimerFeature()
    }
    Reduce { state, action in
        return .none
    }
}
```
