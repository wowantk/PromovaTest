//
//  ImageListView.swift
//

import SwiftUI
import ComposableArchitecture

struct AnimalListView: View {
    
    let store: StoreOf<AnimalListCore>
    
    @State private var shouldPresentAnimal = false
    @State private var shouldPresentAdAlert = false
    @State private var shouldPresentComingSoonAlert = false
    
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    List(viewStore.animals, id: \.id) { animal in
                        if animal.state != .comingSoon {
                            NavigationLink(
                                destination: AnimalFactView(store: Store(initialState: AnimalFactCore.State(facts: animal.facts)){
                                    AnimalFactCore()
                                }) {
                                    viewStore.send(.factViewDismissed)
                                },
                                isActive:  viewStore.binding(
                                    get: { $0.shouldShowAnimalFact && $0.selectedAnimal?.id == animal.id },
                                    send: { _ in .none }
                                ),
                                label: {
                                    AnimalCellView(model: animal)
                                        .onTapGesture {
                                                viewStore.send(.showAnimalFact(animal))
                                        }
                                }
                            )
                        } else {
                            AnimalCellView(model: animal)
                                .onTapGesture {
                                    viewStore.send(.showComingSoon)
                                }
                        }
                    }
                    if viewStore.isLoading {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .zIndex(1) 
                    }
                }
                .navigationTitle("Animal Fact")
                .onAppear {
                    viewStore.send(.fetchAnimals)
                }
                .alert(
                    item: viewStore.binding(
                        get: { $0.alertToShow },
                        send: { .alertClosed }()
                    ),
                    content: { alertToShow in
                        switch alertToShow {
                        case .showAlertAd:
                            return Alert(
                                title: Text("Watch Ad to continue"),
                                primaryButton: .default(
                                    Text("Show Ad"),
                                    action: { viewStore.send(.showAdTapped)
                                    }
                                ),
                                secondaryButton: .cancel(
                                    Text("Cancel"),
                                    action: { viewStore.send(.alertClosed) }
                                )
                            )
                        case .showAlertcomingSoon:
                            return Alert(
                                title: Text("Coming Soon"),
                                dismissButton: .default(
                                    Text("OK"),
                                    action: {
                                        viewStore.send(.alertClosed)
                                    }
                                )
                            )
                        }
                    }
                )
            }
        }
        
    }
}


#Preview {
    AnimalListView(store: Store(initialState: AnimalListCore.State()) {
        AnimalListCore()
    }
    )
}
