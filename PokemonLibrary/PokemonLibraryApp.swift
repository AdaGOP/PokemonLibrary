//
//  PokemonLibraryApp.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 30/04/25.
//

import SwiftUI

@main
struct PokemonLibraryApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
        }
    }
}
