//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Ivan Setiawan on 08/05/25.
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
    @Published private(set) var name: String = ""
    @Published private(set) var height: String = ""
    @Published private(set) var weight: String = ""
    @Published private(set) var abilities: [String] = []
    @Published private(set) var image: Image? = nil
    
    func onAppear(_ pokemon: Pokemon) {

        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                changeDetail(detail)
                loadImage(from: URL(string: detail.sprites.other.officialArtwork.url)!)
                updateState(.loaded(detail))
            } catch let error as NetworkError {
                updateState(.error(error))
            } catch {
                updateState(.error(.unknown))
            }
        }
    }
}

private extension DetailViewModel {
    func changeDetail(_ detail: PokemonDetailResponse) {
        DispatchQueue.main.async {
            self.name = detail.name.capitalized
            self.height = "\(detail.height) cm"
            self.weight = "\(detail.weight) kg"
            self.abilities = detail.abilities.map { $0.ability.name.capitalized }
        }
    }
    
    
    func changeImage(_ image: Image) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
    
    func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    changeImage(Image(uiImage: uiImage))
                }
            }
        }
    }
            
    func updateState(_ state: DetailViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    
}
