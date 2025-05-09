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
            Group{
                switch viewModel.state {
                case .loading:
                    Text("Loading...")
                case .loaded(let pokemon):
                    AsyncImage(url: URL(string: pokemon.sprites.other.officialArtwork.url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }

                    
                    VStack(spacing: 8.0) {
                        Text(viewModel.name)
                            .font(.title2)
                            .bold()
                            .padding(.top, 16.0)
                        
                        Text("Height: \(viewModel.height)")
                        Text("Weight: \(viewModel.weight)")
                        
                        Text("Abilities:")
                            .font(.title3)
                            .bold()
                            .padding(.top, 16.0)
                        
                        ForEach(viewModel.abilities, id: \.self) { ability in
                            Text(ability)
                        }
                    }
                case .error(let networkError):
                    Text("Error: \(String(describing: networkError.errorDescription))")
                }
            }
        }.onAppear {
            viewModel.loadPokemonDetail()
        }
    }

}
