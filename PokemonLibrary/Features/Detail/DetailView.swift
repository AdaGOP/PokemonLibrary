//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import SwiftUI
import Foundation

struct DetailView: View {
    let pokemonSelected: Pokemon
    @StateObject var viewModel:DetailViewModel
    
    init(pokemonSelected: Pokemon) {
        self.pokemonSelected = pokemonSelected
        _viewModel = StateObject(wrappedValue: DetailViewModel(pokemon: pokemonSelected))
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Text("Loading...")
            case .loaded(let pokemon):
                Group {
                    if let image = viewModel.image {
                        image
                            .resizable()
                            .frame(width: 200, height: 200)
                    } else {
                        Image(systemName: "xmark.octagon")
                    }
                }

                VStack(spacing: 8.0) {
                    Text(pokemon.name)
                        .font(.title2)
                        .bold()
                        .padding(.top, 16.0)
                    
                    Text("Height: \(pokemon.height)")
                    Text("Weight: \(pokemon.weight)")
                    
                    Text("Abilities:")
                        .font(.title3)
                        .bold()
                        .padding(.top, 16.0)
                    
                    ForEach(pokemon.abilities, id: \.ability.name) { ability in
                        Text(ability.ability.name)
                    }
                }
            case .error(let networkError):
                Text("Error: \(networkError.errorDescription)")
            }
        }
        .onAppear {
            viewModel.loadPokemonDetail()
        }
    }
}
