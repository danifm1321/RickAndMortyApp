//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import SwiftUI

//For this exercise, you can use this API Client por Swift: https://github.com/benjaminbruch/Rick-and-Morty-Swift-API
//However, I chose not to use it to demostrate my knowledge about REST.

@main
struct RickAndMortyAppApp: App {
    var body: some Scene {
        WindowGroup {
            CharactersList()
        }
    }
}
