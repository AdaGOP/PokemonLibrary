//
//  HomeView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    
    @State var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                switch viewModel.state {
                case .loading:
                    Text("Loading...")
                case .loaded(let pokemons):
                    List(pokemons, id: \.name) { pokemon in
                        HStack {
                            Text(pokemon.name.capitalized)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            navigationPath.append(pokemon)
                        }
                    }
                case .error(let networkError):
                    Text("Error: \(String(describing: networkError.errorDescription))")
                }
            }
            .navigationTitle("Pokémon List")
            .navigationDestination(for: Pokemon.self) { selected in
                DetailView(viewModel:     .init(pokemon: selected))
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .searchable(text: $viewModel.searchText, prompt: "Search your favorite pokémon")
    }
}
