//
//  ImageListViewCore.swift
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AnimalListCore {
    struct State: Equatable {
        var animals: IdentifiedArrayOf<AnimalModel> = []
        var loadingState: LoadingState = .loading
        var alertToShow: AnimalsListAlert?
        var shouldShowAnimalFact: Bool = false
        var selectedAnimal: AnimalModel?
        
        var isLoading: Bool {
            loadingState == .loading
        }
        
    }
    
    enum LoadingState: Equatable {
        case loading
        case loaded
        case failed(String)
    }
    
    enum Action {
        case fetchAnimals
        case animalResponse(Result<IdentifiedArrayOf<AnimalModel>, Error>)
        case showAnimalFact(AnimalModel)
        case alertClosed
        case factViewDismissed
        case showAdTapped
        case showComingSoon
        case adEnded
        case none
    }
    
    @Dependency(\.animalClient) var animalClient

    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action {
            case .fetchAnimals:
                return .run{ send in
                    await send(.animalResponse(Result{ try await self.animalClient.animals() }))
                }
            case let .animalResponse(.failure(error)):
                state.animals = []
                state.loadingState = .failed(error.localizedDescription)
                return .none
            case let .animalResponse(.success(response)):
                state.animals = response
                state.loadingState = .loaded
                return .none
            case let .showAnimalFact(element):
                switch element.state {
                case .free:
                    state.shouldShowAnimalFact = true
                    state.selectedAnimal = element
                    return .none
                case .paid:
                    state.alertToShow = .showAlertAd(selectedAnimal: element)
                    state.selectedAnimal = element
                    return .run { send in
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        await send(.adEnded)
                    }
                case .comingSoon:
                    state.alertToShow = .showAlertcomingSoon
                    return .none
                }
            case .alertClosed:
                state.alertToShow = .none
                return .none
            case .showComingSoon:
                state.alertToShow = .showAlertcomingSoon
                return .none
            case .showAdTapped:
                state.loadingState = .loading
                return .none
            case .adEnded:
                state.loadingState = .loaded
                state.alertToShow = .none
                state.shouldShowAnimalFact = true
                return .none
            case .factViewDismissed:
                state.shouldShowAnimalFact = false
                state.selectedAnimal = nil
                return .none
            case .none:
                return .none
            }
        }
    }
}

enum AnimalsListAlert: Identifiable, Equatable {
    case showAlertAd(selectedAnimal: AnimalModel)
    case showAlertcomingSoon
    var id: Int {
        switch self {
        case .showAlertAd(let selectedAnimal):
            return selectedAnimal.id.hashValue
        case .showAlertcomingSoon:
            return 0
        }
    }
}


