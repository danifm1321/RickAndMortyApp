//
//  PaginableList.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 7/9/23.
//

import SwiftUI

struct PaginableList : View {
    
    @State private var pageInfo : PageInfo = PageInfo()
    @State private var errorText = ""
    @State private var dataLoaded = false
    @State private var searchText = ""
    
    var body: some View {
        
        VStack {
                
            //To avoid making a request everytime the user introduces a new letter, we use TextField and only make a request when the user presses "Intro"
            TextField("Search by name", text: $searchText, onCommit: {
                if searchText == "" {
                    //Building the API URL
                    guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
                        errorText = "An error occurred bulding the URL."
                        pageInfo = PageInfo()
                        return
                    }
                    
                    getPageInfo(url: url)
                } else {
                    //Building the API URL
                    guard let url = URL(string: "https://rickandmortyapi.com/api/character/?name=\(searchText)") else {
                        errorText = "An error occurred bulding the URL."
                        pageInfo = PageInfo()
                        return
                    }
                    
                    getPageInfo(url: url)
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if errorText == "" {
                List(pageInfo.results) { character in
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

            HStack {
                if pageInfo.info.prev != nil {
                    Button(action: {loadPreviousCharacters()}) {
                        Text("Prev.")
                            .foregroundColor(.primary)
                    }
                    .buttonStyle()
                }
                
                Spacer()
                
                if pageInfo.info.next != nil {
                    Button(action: {loadNextCharacters()}) {
                        Text("Next")
                            .foregroundColor(.primary)
                    }
                    .buttonStyle()
                }
            }
            .padding(.horizontal, 10)
            
            Spacer()
        }
        .onAppear() {
            
            //Building the API URL
            guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
                errorText = "An error occurred bulding the URL."
                pageInfo = PageInfo()
                return
            }
            
            if !dataLoaded {
                getPageInfo(url: url)
            }
        }

    }
    
    func loadPreviousCharacters() {
        if pageInfo.info.prev != nil {
            //Building the API URL
            guard let url = URL(string: pageInfo.info.prev!) else {
                errorText = "An error occurred bulding the URL."
                pageInfo = PageInfo()
                return
            }
            
            getPageInfo(url: url)
        }
    }
    
    func loadNextCharacters() {
        if pageInfo.info.next != nil {
            
            //Building the API URL
            guard let url = URL(string: pageInfo.info.next!) else {
                errorText = "An error occurred bulding the URL."
                pageInfo = PageInfo()
                return
            }
            
            getPageInfo(url: url)
        }
    }
    
    func getPageInfo(url : URL) {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad

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
                        dataLoaded = true
                        errorText = ""
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
