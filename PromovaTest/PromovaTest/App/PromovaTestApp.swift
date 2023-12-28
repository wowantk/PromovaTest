//
//  PromovaTestApp.swift
//  PromovaTest
//
//  Created by Volodymyr Drobot on 22.12.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct PromovaTestApp: App {
    var body: some Scene {
        WindowGroup {
            AnimalListView(store: Store(initialState: AnimalListCore.State()) {
                AnimalListCore()
                    ._printChanges()
            }
            )
        }
    }
}
