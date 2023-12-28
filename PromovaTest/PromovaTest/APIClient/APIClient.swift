//
//  APIClient.swift
//

import Foundation
import ComposableArchitecture
import Combine

struct AnimalElement: Decodable{
    let title, description: String
    let image: String
    let order: Int
    let status: Status
    let content: [Content]?
}

struct Content: Decodable {
    let fact: String
    let image: String
}

enum Status: String, Decodable {
    case paid, free
}
   


@DependencyClient
struct AnimalClient {
    var animals:   @Sendable () async throws  -> IdentifiedArrayOf<AnimalModel>
}

extension DependencyValues {
    var animalClient: AnimalClient {
        get { self[AnimalClient.self] }
        set { self[AnimalClient.self] = newValue }
    }
}


extension AnimalClient: DependencyKey {
    static let liveValue: AnimalClient = AnimalClient(animals:  {
        var components = URLComponents(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")!
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let decoder = JSONDecoder()
        let result = try decoder.decode([AnimalElement].self, from: data)
        let sorted = result.sorted { $0.order < $1.order }
        let models = sorted.map { ModelBuilder().makeModel(from: $0) }
        let identifiedArray: IdentifiedArrayOf<AnimalModel> = IdentifiedArrayOf(uniqueElements: models, id: \.id)
        return identifiedArray
    })
}

extension AnimalModel {
    static let mock = [Self(name: "Dragons 🐉", description: "Dragons not real, but beautiful :)", state: .comingSoon, imageUrl: URL(string: ""), facts: [.init(content: "Funny", imageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg")!)])]
}
