# Effect.Timer

已废弃, 可以使用 Combine 或者 publisher

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
