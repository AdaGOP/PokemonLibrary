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
    @Published var image: Image? = nil
    
    func loadPokemonDetail(pokemon: Pokemon) {
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                
                if let imageURL = URL(string: detail.sprites.other.officialArtwork.url) {
                    await loadImage(from: imageURL)
                }
                
                updateState(DetailViewState.loaded(detail))
            } catch let error as NetworkError {
                updateState(.error(error))
            }
            catch {
                updateState(.error(.unknown))
            }
        }
    }
    
    func loadImage(from url: URL) async {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    
                    self.image = Image(uiImage: uiImage)
                    
                }
            } catch {
                print("Failed to load image: \(error.localizedDescription)")
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
