//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Nur Fajar Sayyidul Ayyam on 08/05/25.
//

import Foundation
import SwiftUI

enum DetailViewState {
    case loading
    case loaded(PokemonDetail)
    case error(NetworkError)
}

final class DetailViewModel : ObservableObject{
    
    @Published private(set) var state: DetailViewState = .loading
    
    func loadPokemonDetail(pokemon: Pokemon) {
        updateState(.loading)
        
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                let image : Image? = await loadImage(from: URL(string: detail.sprites.other.officialArtwork.url)!)
                let pokemonDetail : PokemonDetail = PokemonDetail(
                    name: detail.name.capitalized,
                    abilities: detail.abilities.map { $0.ability.name.capitalized },
                    height: "\(detail.height) cm",
                    weight: "\(detail.weight) kg",
                    image: image
                )
                updateState(.loaded(pokemonDetail))
            } catch let error as NetworkError {
                updateState(.error(error))
            } catch {
                updateState(.error(.unknown))
            }
        }
    }
}

private extension DetailViewModel {
    func loadImage(from url: URL) async -> Image? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        return nil
    }
    
    
    func updateState(_ state: DetailViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}
