//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Jerry Febriano on 08/05/25.
//

import SwiftUI

enum DetailViewState {
    case loading
    case loaded(PokemonDetailResponse)
    case error(NetworkError)
}

class DetailViewModel: ObservableObject {
    let pokemon: Pokemon
    @Published private(set) var state: DetailViewState = .loading
    private var networkService: NetworkService

    init(
        pokemon: Pokemon,
        networkService: NetworkService = NetworkService()
    ) {
        self.pokemon = pokemon
        self.networkService = networkService
    }

    func loadPokemonDetail() {
        updateState(.loading)

        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService()
                    .request(.getPokemonDetail(urlString: pokemon.url))

                updateState(.loaded(detail))
            } catch let error as NetworkError {
                updateState(.error(error))
            } catch {
                updateState(.error(.unknown))
            }
        }
    }
}

extension DetailViewModel {
    private func updateState(_ newState: DetailViewState) {
        DispatchQueue.main.async {
            self.state = newState
        }
    }

    private func loadImage(from url: URL) async -> Image? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
            return nil
        } catch {
            print(
                "Failed to load image from \(url): \(error.localizedDescription)"
            )
            return nil
        }
    }
}
