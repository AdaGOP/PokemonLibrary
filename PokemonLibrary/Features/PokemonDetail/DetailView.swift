//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Catching Pokémon details...")
                    .progressViewStyle(.circular)
            case .loaded(detail: let pokemon):
                AsyncImage(
                    url: URL(string: pokemon.sprites.other.officialArtwork.url)
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                
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

                    ForEach(
                        pokemon.abilities.map { $0.ability.name.capitalized },
                        id: \.self
                    ) { abilityName in
                        Text(abilityName)
                    }
                }
            case .error(let errorMessage):
                Text(
                    "Error: \(errorMessage.errorDescription ?? "UnknownError")")
            }
        }
        .onAppear {
            viewModel.loadPokemonDetail()
        }
    }

}
