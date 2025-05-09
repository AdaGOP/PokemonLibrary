//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Thingkilia on 08/05/25.
//

import Foundation
import SwiftUICore
import UIKit

enum DetailViewState {
    case loading
    case loaded(PokemonDetailUIModel)
    case error(NetworkError)
}

class DetailViewModel: ObservableObject {
    @Published private(set) var state: DetailViewState = .loading
    
    func loadPokemonDetail(pokemonUrl: String) {
        updateState(.loading)
        
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemonUrl))
                let image = await loadImage(from: detail.sprites.other.officialArtwork.url)
                
                updateState(.loaded(PokemonDetailUIModel.fromResponse(detail, image: image)))
            } catch let error as NetworkError {
                updateState(.error(error))
            } catch {
                updateState(.error(.unknown))
            }
        }
    }
    
    func loadImage(from imageUrl: String) async -> Image? {
        do {
            guard let url = URL(string: imageUrl) else { return nil }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        } catch {
            return nil
        }
        
        return nil
    }
}

private extension DetailViewModel {
    func updateState(_ state: DetailViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}
