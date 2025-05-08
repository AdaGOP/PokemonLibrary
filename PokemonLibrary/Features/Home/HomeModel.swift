//
//  HomeModel.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import Foundation

struct PokemonListResponse: Decodable {
    let results: [Pokemon]
}
    
struct Pokemon: Codable, Hashable {
    let name: String
    let url: String
}
