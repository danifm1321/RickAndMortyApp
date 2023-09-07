//
//  PaginableList.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 7/9/23.
//

import SwiftUI

struct PaginableList : View {
    
    @State private var pageInfo : PageInfo = PageInfo()
    
    @State private var showErrorAlert = false
    @State private var errorText = ""
    
    @State private var dataLoaded = false
    
    @State private var searchText = ""

    
    var body: some View {
        
        VStack {
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
            
            List(pageInfo.results) { character in
                CharacterRow(character: character)
            }
            .searchable(text: $searchText, prompt: "Search by name")
            .onChange(of: searchText) {_ in
                if searchText == "" {
                    //Building the API URL
                    guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
                        showErrorAlert = true
                        errorText = "An error occurred bulding the URL."
                        return
                    }
                    
                    getPageInfo(url: url)
                } else {
                    //Building the API URL
                    guard let url = URL(string: "https://rickandmortyapi.com/api/character/?name=\(searchText)") else {
                        showErrorAlert = true
                        errorText = "An error occurred bulding the URL."
                        return
                    }
                    
                    getPageInfo(url: url)
                }
            }
            
            Spacer()
        }
        //Alert if an error has occurred
        .alert(errorText, isPresented: $showErrorAlert) {
            Button("Ok") {}
        }
        .onAppear() {
            
            //Building the API URL
            guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
                showErrorAlert = true
                errorText = "An error occurred bulding the URL."
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
                showErrorAlert = true
                errorText = "An error occurred bulding the URL."
                return
            }
            
            getPageInfo(url: url)
        }
    }
    
    func loadNextCharacters() {
        if pageInfo.info.next != nil {
            
            //Building the API URL
            guard let url = URL(string: pageInfo.info.next!) else {
                showErrorAlert = true
                errorText = "An error occurred bulding the URL."
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
                        pageInfo = parsePageInfo(data: data!)
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
