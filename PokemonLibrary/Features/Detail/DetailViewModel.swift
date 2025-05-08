//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Regina Celine Adiwinata on 08/05/25.
//

import Foundation
import SwiftUI

enum DetailViewState {
    case loading
    case loaded(PokemonDetailResponse)
    case error(NetworkError)
}

class DetailViewModel: ObservableObject {
    @Published private(set) var state: DetailViewState = .loading
    @Published var image: Image? = nil
    
    private let pokemon: Pokemon

        init(pokemon: Pokemon) {
            self.pokemon = pokemon
        }
    
    func loadPokemonDetail() {
        
        updateState(.loading)

        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                if let url = URL(string: detail.sprites.other.officialArtwork.url) {
                    await loadImage(from: url)
                }
                updateState(.loaded(detail))
            }
            catch let error as NetworkError {
                updateState(.error(error))
            }
            catch {
                updateState(.error(.unknown))
            }
        }
    }
    
    private func updateState(_ state: DetailViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }

    func loadImage(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                let img = Image(uiImage: uiImage)
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.image = nil
            }
        }
    }
}
