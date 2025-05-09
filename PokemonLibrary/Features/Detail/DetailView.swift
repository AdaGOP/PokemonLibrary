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
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Text("Loading...")
            case .loaded(let pokemon):
                if let image = pokemon.image {
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                } else {
                    Image(systemName: "xmark.octagon")
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
                    
                    ForEach(pokemon.abilities, id: \.self) { ability in
                        Text(ability)
                    }
                }
            
            
            case .error(let networkError):
                Text("Error: \(networkError.errorDescription ?? "Unknown error")")
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

}
