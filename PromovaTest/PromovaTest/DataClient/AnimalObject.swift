//
//  AnimalModel.swift
//
import Foundation
import SwiftUI

struct AnimalModel: Identifiable, Equatable, Sendable {
    let id = UUID()
    let name: String
    let description: String
    var state: CategoryState
    let imageUrl: URL?
    let facts: [FactModel]
}

enum CategoryState: LocalizedStringKey {
    case free
    case paid
    case comingSoon
}

struct FactModel: Identifiable, Equatable{
    let id = UUID()
    let content: String
    let imageUrl: URL
}


struct ModelBuilder {
    func makeModel(from result: AnimalElement) -> AnimalModel {
        var state: CategoryState
        switch result.status {
        case .paid:
            state = .paid
        case .free:
            state = .free
        }
        var factModels: [FactModel] = []
        if let content = result.content {
            factModels = content.compactMap { makeContentModel(from: $0) }
        } else {
            state = .comingSoon
        }
        return AnimalModel(
            name: result.title,
            description: result.description,
            state: state,
            imageUrl: URL(string: result.image),
            facts: factModels
        )
    }
    
    private func makeContentModel(from content: Content) -> FactModel {
        FactModel(content: content.fact, imageUrl: URL(string: content.image)!)
    }
}
