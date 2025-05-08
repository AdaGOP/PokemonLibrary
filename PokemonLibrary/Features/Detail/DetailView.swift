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
    
    @State var name: String = ""
    @State var abilities: [String] = []
    @State var height: String = ""
    @State var weight: String = ""
    @State var image: Image? = nil
    @State var isLoading: Bool = true
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Text("Loading…")
            case .loaded(let pokemonResponse):
                VStack(spacing: 8.0) {
                    if let image = image {
                        image
                            .resizable()
                            .frame(width: 200, height: 200)
                    } else {
                        Image(systemName: "xmark.octagon")
                            .onAppear{
                                loadImage(from: URL(string: pokemonResponse.sprites.other.officialArtwork.url)!)
                            }
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
    
    func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                }
            }
        }
    }
}
