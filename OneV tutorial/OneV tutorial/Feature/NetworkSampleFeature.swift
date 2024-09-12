//
//  NetworkSampleFeature.swift
//  OneV tutorial
//
//  Created by lianxinbo on 2024/9/12.
//

import ComposableArchitecture
import Foundation

@Reducer
struct NetworkSampleFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var loading: Bool
        
        var text: String
    }
    
    enum Action {
        
        case load
        
        case loaded(Result<String, URLError>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                return .run { send in
                    let result = await networkSample.loadText()
                    await send(.loaded(result))
                }
            case .loaded(let result):
                do {
                    state.text = try result.get()
                } catch {
                    state.text = "Error: \(error)"
                }
                return .none
            }
        }
    }
    
    @Dependency(\.networkSample) var networkSample
}

struct NetworkSampleFeatureEnvironment: DependencyKey {
    
    var loadText: () async -> Result<String, URLError>
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let liveValue: NetworkSampleFeatureEnvironment = NetworkSampleFeatureEnvironment(
        loadText: {
            do {
                let (data, response) = try await URLSession.shared
                    .data(from: URL(string: "https://httpbin.org/get?i=1")!)
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

extension DependencyValues {
    
    var networkSample: NetworkSampleFeatureEnvironment {
        get { self[NetworkSampleFeatureEnvironment.self] }
        set { self[NetworkSampleFeatureEnvironment.self] = newValue }
    }
}

