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

    

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Text("Loading…")
            case .loaded(let pokemonDetailResponse):
            
                
                if let image = viewModel.image {
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                } else {
                    Image(systemName: "xmark.octagon")
                }

                VStack(spacing: 8.0) {
                    Text(pokemonDetailResponse.name.capitalized)
                        .font(.title2)
                        .bold()
                        .padding(.top, 16.0)
                    
                    Text("Height: \(pokemonDetailResponse.height)")
                    Text("Weight: \(pokemonDetailResponse.weight)")
                    
                    Text("Abilities:")
                        .font(.title3)
                        .bold()
                        .padding(.top, 16.0)
                    
                    ForEach(pokemonDetailResponse.abilities.map { $0.ability.name.capitalized }, id: \.self) { ability in
                        Text("\(ability)")
                    }
                }
            case .error(let networkError):
                Text("Error: \(networkError.errorDescription ?? "Unknown")")
            }
        }
        .onAppear {
            viewModel.loadPokemonDetail(url: pokemon.url)
        }
    }

    
}
