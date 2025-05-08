//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import SwiftUI
import Foundation

struct DetailView: View {
    let pokemon: Pokemon
    
    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Text("Loading…")
            case .loaded(let pokemonDetail):
                if let image = pokemonDetail.image {
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                } else {
                    Image(systemName: "xmark.octagon")
                }
                
                VStack(spacing: 8.0) {
                    Text(pokemonDetail.name)
                        .font(.title2)
                        .bold()
                        .padding(.top, 16.0)
                    
                    Text("Height: \(pokemonDetail.height)")
                    Text("Weight: \(pokemonDetail.weight)")
                    
                    Text("Abilities:")
                        .font(.title3)
                        .bold()
                        .padding(.top, 16.0)
                    
                    ForEach(pokemonDetail.abilities, id: \.self) { ability in
                        Text(ability)
                    }
                }
            case .error(let error):
                Text("Error: \(error.errorDescription ?? "")")
            }
        }
        .onAppear {
            viewModel.loadPokemonDetail(pokemon: pokemon)
        }
    }
}
