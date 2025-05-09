//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Rico Tandrio on 08/05/25.
//

import Foundation
import SwiftUI

enum DetailViewState {
    case loading
    case loaded(PokemonDetail)
    case error(NetworkError)
}

class DetailViewModel: ObservableObject {
    
    private var pokemon: Pokemon
    
    @Published private(set) var state: DetailViewState = .loading
    
    init (pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func onAppear() {
        updateState(.loading)
        
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                
                var image: Image?
                
                if let url = URL(string: detail.sprites.other.officialArtwork.url) {
                    image = await loadImage(from: url)
                }
                
                updateState(.loaded(
                    PokemonDetail(
                        name: detail.name.capitalized,
                        height: "\(detail.height) cm",
                        weight: "\(detail.weight) kg",
                        abilities: detail.abilities.map { $0.ability.name.capitalized },
                        image: image
                    )
                ))

            } catch let error as NetworkError {
                updateState(.error(error))
            } catch {
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
    
    func loadImage(from url: URL) async -> Image? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        } catch {
            print("Error loading image: \(error)")
        }
        
        return nil
    }

}
