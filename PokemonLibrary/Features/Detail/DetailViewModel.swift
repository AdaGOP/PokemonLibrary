//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Zakia Noorardini on 08/05/25.
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
    
    @Published var name: String = ""
    @Published var abilities: [String] = []
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var image: Image? = nil
    
    func loadPokemonDetail(url: String) {
        updateState(.loading)
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: url))
                name = detail.name.capitalized
                height = "\(detail.height) cm"
                weight = "\(detail.weight) kg"
                abilities = detail.abilities.map { $0.ability.name.capitalized }
                
                loadImage(from: URL(string: detail.sprites.other.officialArtwork.url)!)
                updateState(.loaded)
            } catch let error as NetworkError{
                updateState(.error(error))
            } catch {
                updateState(.error(.unknown))
            }
        }
    }
    
    func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                }
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
