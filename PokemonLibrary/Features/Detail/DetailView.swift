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
    @StateObject var viewModel = DetailViewModel()

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Text("Loading Pokémon details...")

            case .loaded:
                if let image = viewModel.image {
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                }

                VStack(spacing: 8) {
                    Text(viewModel.name)
                        .font(.title2)
                        .bold()

                    Text("Height: \(viewModel.height)")
                    Text("Weight: \(viewModel.weight)")

                    Text("Abilities:")
                        .font(.title3)
                        .bold()
                        .padding(.top, 8)

                    ForEach(viewModel.abilities, id: \.self) { ability in
                        Text(ability)
                    }
                }

            case .error(let error):
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("Error: \(error.errorDescription ?? "Unknown error")")
                        .multilineTextAlignment(.center)
                }
            }
        }
        .onAppear {
            viewModel.onAppear(pokemon: pokemon)
        }
        .navigationTitle(viewModel.name.isEmpty ? "Detail" : viewModel.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
