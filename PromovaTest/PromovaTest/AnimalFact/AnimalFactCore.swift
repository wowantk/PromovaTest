//
//  AnimalFactCore.swift
//

import Foundation
import ComposableArchitecture

@Reducer
struct AnimalFactCore {
    struct State: Equatable {
        @BindingState var factIndex: Int = 0
        var facts: [FactModel]
        var selectedFact: FactModel {
            facts[factIndex]
        }
    }
    
    enum Action: BindableAction {
        case nextFact
        case prvFact
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action>  {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .nextFact:
                let nextIndex = state.factIndex + 1
                if nextIndex < state.facts.count {
                    state.factIndex = nextIndex
                }
                return .none
            case .prvFact:
                let nextIndex = state.factIndex - 1
                if nextIndex >= 0 {
                    state.factIndex = nextIndex
                }
                return .none
            }
        }
    }
}
