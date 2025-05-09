//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Ahmad Al Wabil on 08/05/25.
//


import Foundation
import SwiftUI

enum DetailViewState{
    case loading
    case loaded(PokemonDetailResponse)
    case error(NetworkError)
}

class DetailViewModel: ObservableObject{
    let pokemon: Pokemon
    @Published var state: DetailViewState = .loading
    
    @Published private(set) var name: String = ""
    @Published private(set) var height: String = ""
    @Published private(set) var weight: String = ""
    @Published private(set) var abilities: [String] = []
    @Published private(set) var image: Image?
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        loadPokemonDetail()
    }
    
    func loadPokemonDetail() {
        
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                
               
                
                await MainActor.run {
                    name = detail.name.capitalized
                    height = "\(detail.height) cm"
                    weight = "\(detail.weight) kg"
                    abilities = detail.abilities.map { $0.ability.name.capitalized }
                    if let url = URL(string: detail.sprites.other.officialArtwork.url) {
                        loadImage(from: url)
                    }
                    print("✅ Berhasil memuat data dari API untuk \(detail.name)")
                    
                }
                
                updateState(.loaded(detail))
                
            } catch let error as NetworkError  {
                updateState(.error(error))
                
            }catch{
                updateState(.error(.unknown))
            }
        }
    }
    
    func loadImage(from url: URL){
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        image = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
    
    
}

private extension DetailViewModel{
    func updateState(_ state: DetailViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
}
