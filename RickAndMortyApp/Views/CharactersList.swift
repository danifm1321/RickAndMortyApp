//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import SwiftUI

struct CharactersList: View {
    
    @State private var pageInfo : PageInfo = PageInfo()

    @State private var characters : [RickAndMortyCharacter] = []
    @State private var filteredCharacters : [RickAndMortyCharacter] = []
    @State private var searchText = ""
    
    @State private var errorText = ""
    
    //Variable that controls the petition is launched only once
    @State private var dataLoaded = false
    
    var body: some View {
        
        VStack {
            
            TextField("Search by name", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if errorText == "" {
                List(filteredCharacters) { character in
                    
                    NavigationLink(value: character) {
                        CharacterRow(character: character)
                    }
                    //This improves the list performance when updating
                    .id(character.id)
                }
            } else {
                Spacer()
                
                Text(errorText)
            }
            
            Spacer()
        }
        //The characters get filtered without making any new request, so can be done in the onChange
        .onChange(of: searchText) { _ in
            reloadFilteredCharacters()
        }
        //If the characters update, the filtered characters need to be updated
        .onChange(of: characters) {_ in
            reloadFilteredCharacters()
        }
        .onAppear {
            //It is necessary to load the data only once
            if !dataLoaded {
                
                //Building the API URL
                guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
                    errorText = "An error occurred bulding the URL."
                    pageInfo = PageInfo()
                    return
                }
                
                getCharacters(url: url)
            }
        }
    }
    
    func reloadFilteredCharacters() {
        if searchText == "" {
            
            //If the search text is blank, show all the characters
            filteredCharacters = characters
        } else {
            
            //Else, we filter by name lowercased, to allow more flexibility introducing the name
            filteredCharacters = characters.filter({$0.name.lowercased().contains(searchText.lowercased())})
        }
    }
    
    func getCharacters(url : URL) {
        
        //Setting the cache policy
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        //Creating the session and the task
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { (data, response, error) in
                
            //Notify if an error has occurred
            if error != nil {
                errorText = "An error has occurred. Please, check your connection or try again later."
                pageInfo = PageInfo()
            } else {
                
                //Getting the response as HTTPURLResponse to get the status code, in case there is some failure in the API
                if let urlResponse = response as? HTTPURLResponse {

                    //Getting the status code
                    let statusCode = urlResponse.statusCode

                    if statusCode != 200 {
                        
                        //Notify if the status code isn't 200
                        errorText = "An error has occurred. Code \(statusCode)."
                        pageInfo = PageInfo()
                    } else {
                        pageInfo = parsePageInfo(data: data!)
                        
                        //Add the new characters to de array
                        characters.append(contentsOf: pageInfo.results)
                        dataLoaded = true
                        errorText = ""
                        
                        //If a next page exists, load it
                        if pageInfo.info.next != nil {
                            guard let urlAux = URL(string: pageInfo.info.next!) else {
                                errorText = "An error occurred bulding the URL."
                                pageInfo = PageInfo()
                                return
                            }
                            
                            getCharacters(url: urlAux)
                        }
                    }
                } else {
                    errorText = "An error has occurred. Please, check your connection or try again later."
                    pageInfo = PageInfo()
                }
            }
        }
        
        task.resume()
    }
}
