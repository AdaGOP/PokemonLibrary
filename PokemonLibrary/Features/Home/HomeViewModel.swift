//
//  HomeViewModel.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 08/05/25.
//

import Foundation
import SwiftUI
import Combine

enum HomeViewState {
    case loading
    case loaded([Pokemon])
    case error(NetworkError)
}

final class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = "" {
        didSet {
            //#MARK: - 1. Fix the textfield always invoke the code on every type
            // Every Changes on every stroke of code typing will trigger this. This will slow down the code eventually if we have more custom logic on the search function
            // To fix this we need to create the apply search event only occurs when certain time of time is passed. This will be on the init function
            //applySearch()
        }
    }
    private var cancelable = Set<AnyCancellable>()
    
    init(){
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { _ in
                print("changes happen")
                self.applySearch()
            }
            .store(in: &cancelable)
    }
    
    
    
    @Published private(set) var state: HomeViewState = .loading
    

    private var allPokemons: [Pokemon] = []
    
    func fetchPokemons() {
        updateState(.loading)

        Task {
            do {
                let response: PokemonListResponse = try await NetworkService().request(.getPokemons)
                allPokemons = response.results
                updateState(.loaded(response.results))
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

private extension HomeViewModel {
    func updateState(_ state: HomeViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    func applySearch() {
        // You can also get the enum variables using this
        // Use pattern matching on the enum to get the value inside the enum
        // Use guard to make the code not filled with conditional statement
        // Guard case let .loaded(allPokemons) = state else { return }
        
        if searchText.isEmpty {
            updateState(.loaded(allPokemons))
        }
        else {
            let filteredPokemons: [Pokemon] = allPokemons.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            updateState(.loaded(filteredPokemons))
        }
    }
}
