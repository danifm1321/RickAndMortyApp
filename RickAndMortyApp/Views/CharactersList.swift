//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import SwiftUI

struct CharactersList: View {
    
    @State private var characters : [Character] = []
    
    @State private var filteredCharacters : [Character] = []
    @State private var searchText = ""
    
    @State private var showErrorAlert = false
    @State private var errorText = ""
    
    //Variable that controls the petition is launched only once
    @State private var dataLoaded = false
    
    var body: some View {
        NavigationStack {
            List(filteredCharacters) { character in
                
                NavigationLink(value: character) {
                    CharacterRow(character: character)
                }
                //This improves the list performance when filtering
                .id(character.id)
            }
            .searchable(text: $searchText, prompt: "Search by name")
            .onChange(of: searchText) { _ in
                
                if searchText == "" {
                    
                    //If the search text is blank, show all the characters
                    filteredCharacters = characters
                } else {
                    
                    //Else, we filter by name lowercased, to allow more flexibility introducing the name
                    filteredCharacters = characters.filter({$0.name.lowercased().contains(searchText.lowercased())})
                }
            }
            .navigationDestination(for: Character.self) { character in
                CharacterDetailView(character: character)
            }
        }
        //Alert if an error has occurred
        .alert(errorText, isPresented: $showErrorAlert) {
            Button("Ok") {}
        }
        .onAppear {
            //It is necessary to load the data only once
            if !dataLoaded {
                getCharacters()
            }
        }
    }
    
    func getCharacters() {
        //Building the API URL
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            showErrorAlert = true
            errorText = "An error occurred bulding the URL."
            return
        }
        
        //Creating the session and the task
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            //Notify if an error has occurred
            if error != nil {
                self.showErrorAlert = true
                self.errorText = "An error has occurred. Please, check your connection or try again later."
            } else {
                
                //Getting the response as HTTPURLResponse to get the status code, in case there is some failure in the API
                if let urlResponse = response as? HTTPURLResponse {

                    //Getting the status code
                    let statusCode = urlResponse.statusCode

                    if statusCode != 200 {
                        
                        //Notify if the status code isn't 200
                        self.showErrorAlert = true
                        self.errorText = "An error has occurred. Code \(statusCode)."
                    } else {
                        characters = parseCharacterList(data: data!)
                        filteredCharacters = characters
                        dataLoaded = true
                    }
                    
                    
                } else {
                    self.showErrorAlert = true
                    self.errorText = "An error has occurred. Please, check your connection or try again later."
                }
            }
        }
        
        task.resume()
    }
}
