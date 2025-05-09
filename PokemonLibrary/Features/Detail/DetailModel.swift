//
//  DetailModel.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import Foundation
import SwiftUICore

struct PokemonDetailUIModel {
    let name: String
    let abilities: [String]
    let height: String
    let weight: String
    let image: Image?
    
    static func fromResponse(_ response: PokemonDetailResponse, image: Image?) -> Self {
        return .init(
            name: response.name.capitalized,
            abilities: response.abilities.map { $0.ability.name.capitalized },
            height: "Height: \(response.height) cm",
            weight: "Weight: \(response.weight) kg",
            image: image,
        )
    }
}

struct PokemonDetailResponse: Decodable {
    let name: String
    let abilities: [Ability]
    let height: Int
    let weight: Int
    let id: Int
    let sprites: Sprites
}

struct Ability: Decodable {
    let ability: AbilityDetail
}

struct AbilityDetail: Decodable {
    let name: String
}

struct Sprites: Decodable {
    let other: SpritesDetail
}

class SpritesDetail: Codable {
    let officialArtwork: SpritesArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.officialArtwork = try container.decode(SpritesArtwork.self, forKey: .officialArtwork)
    }
}

struct SpritesArtwork: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "front_default"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
