//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Mutakin on 08/05/25.
//

import Foundation
import SwiftUI


enum DetailViewState {
    case loading
    case loaded(PokemonDetailResponse)
    case error(NetworkError)
}

class DetailViewModel: ObservableObject {
    
    @Published var state: DetailViewState = .loading
    @Published var image: Image? = nil
    
    func loadPokemonDetail(url: String) {
        state = .loading

        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: url))
                loadImage(from: URL(string: detail.sprites.other.officialArtwork.url)!)
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

    
    func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    let image = Image(uiImage: uiImage)
                    updateImage(image)
                }
            }
        }
    }
    
}


extension DetailViewModel {
    func updateState(_ state: DetailViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    func updateImage(_ image: Image) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
    

}
