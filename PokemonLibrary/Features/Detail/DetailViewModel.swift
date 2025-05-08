//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Frengky Gunawan on 08/05/25.
//

import Foundation
import SwiftUI

enum DetailViewState {
    case loading
    case loaded(PokemonDetailResponse)
    case error(NetworkError)
}

final class DetailViewModel: ObservableObject {
    @Published private(set) var state: DetailViewState = .loading
    
    func loadPokemonDetail(pokemon: Pokemon) {
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                updateState(DetailViewState.loaded(detail))
            } catch let error as NetworkError {
                updateState(.error(error))
            }
            catch {
                updateState(.error(.unknown))
            }
        }
    }
}

private extension DetailViewModel {
    func updateState(_ state: DetailViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}
