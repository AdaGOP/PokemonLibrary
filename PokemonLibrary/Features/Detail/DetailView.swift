//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import SwiftUI
import Foundation

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    let pokemon: Pokemon
    var pokemonDetail: PokemonDetailResponse? = nil
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Text("Loading…")
            case .loaded(let pokemonResponse):
                VStack(spacing: 8.0) {
                    if let image = viewModel.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        Image(systemName: "xmark.octagon")
                    }
                    
                    Text(pokemonResponse.name)
                        .font(.title2)
                        .bold()
                        .padding(.top, 16.0)
                    
                    Text("Height: \(pokemonResponse.height)")
                    Text("Weight: \(pokemonResponse.weight)")
                    
                    Text("Abilities:")
                        .font(.title3)
                        .bold()
                        .padding(.top, 16.0)
                    
                    ForEach(pokemonResponse.abilities, id: \.ability.name) { ability in
                        Text(ability.ability.name)
                    }
                }
            case .error(let networkError):
                Text("Error: \(networkError.errorDescription ?? "")")
                
            }
            
        }
        .onAppear {
            viewModel.loadPokemonDetail(pokemon: pokemon)
        }
    }
}
