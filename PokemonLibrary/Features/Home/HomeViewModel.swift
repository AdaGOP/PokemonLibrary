//
//  HomeViewModel.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 08/05/25.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = "" {
        didSet {
            applySearch()
        }
    }
    @Published private(set) var state: ViewState<[Pokemon]> = .loading
    
    func fetchPokemons() {
        updateState(.loading)

        Task {
            do {
                let response: PokemonListResponse = try await NetworkService().request(.getPokemons)
                allPokemons = response.results
                updateState(.loaded(response.results))
            }
            catch let error as NetworkError {
                updateState(.error(error))
            }
            catch {
                updateState(.error(.unknown))
            }
        }
    }
    
    private var allPokemons: [Pokemon] = []
}

private extension HomeViewModel {
    func updateState(_ state: ViewState<[Pokemon]>) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    func applySearch() {
        if searchText.isEmpty {
            updateState(.loaded(allPokemons))
        }
        else {
            let filteredPokemons: [Pokemon] = allPokemons.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            updateState(.loaded(filteredPokemons))
        }
    }
}
