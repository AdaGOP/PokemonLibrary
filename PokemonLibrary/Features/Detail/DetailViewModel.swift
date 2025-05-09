//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Ferdinand Lunardy on 08/05/25.
//

import Foundation
import SwiftUI

enum DetailViewState {
    case loading
    case loaded
    case error(NetworkError)
}

class DetailViewModel: ObservableObject {
    
    @Published private(set) var state: DetailViewState = .loading
    @Published private(set) var name: String = ""
    @Published private(set) var abilities: [String] = []
    @Published private(set) var height: String = ""
    @Published private(set) var weight: String = ""
    @Published private(set) var image: Image? = nil
    
    func onAppear(pokemon: Pokemon) {
        updateState(.loading)
        
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                
                let mappedAbilities = detail.abilities.map { $0.ability.name.capitalized }
                let displayHeight = "\(detail.height) cm"
                let displayWeight = "\(detail.weight) kg"
                
                var displayImage: Image? = nil
                if let imageUrl = URL(string: detail.sprites.other.officialArtwork.url) {
                    displayImage = try await loadImage(from: imageUrl)
                }

                DispatchQueue.main.async {
                    self.name = detail.name.capitalized
                    self.height = displayHeight
                    self.weight = displayWeight
                    self.abilities = mappedAbilities
                    self.image = displayImage
                    self.updateState(.loaded)
                }
            }
            catch let error as NetworkError {
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
    
    func loadImage(from url: URL) async throws -> Image? {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
