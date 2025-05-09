//
//  ViewState.swift
//  PokemonLibrary
//
//  Created by Thingkilia on 09/05/25.
//

enum ViewState<T> {
    case loading
    case loaded(T)
    case error(NetworkError)
}
