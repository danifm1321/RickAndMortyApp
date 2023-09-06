//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import SwiftUI

//Detail view of a character
struct CharacterDetailView : View {
    
    let character : Character
    
    @State private var episodes : [Episode] = []

    @State private var showErrorAlert = false
    @State private var errorText = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ScrollView {
                Text(character.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                AsyncImage(url: URL(string: character.image)) { image in
                    
                    //Loaded image
                    image
                        .resizable()

                } placeholder: {
                    
                    //Default image if something didn't work
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                }
                .frame(width: 300, height: 300)
                
                
                VStack(alignment: .leading) {
                        
                    HStack {
                        //Dot that changes the color in function of the character status
                        Image(systemName: "circle.fill")
                            .if(character.status == "Alive", transform: {$0.foregroundColor(.green)})
                            .if(character.status == "Dead", transform: {$0.foregroundColor(.red)})
                            .foregroundColor(.gray)
                                
                        Text(character.status + " - " + character.species + " (" + character.gender + ")")
                        
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("Last known location")
                            .foregroundColor(.gray)
                        
                        Text(character.location.name)
                    }
                    .padding(.vertical)

                    VStack(alignment: .leading) {
                        Text("Number of episodes they was seen")
                            .foregroundColor(.gray)
                        
                        Text(String(character.episode.count))
                    }
                    .padding(.vertical)
                }
                .padding()
                
                Spacer()
                
                VStack(alignment: .leading) {
                    
                    Text("List of episodes")
                        .font(.title3)
                    
                    ForEach(episodes) { episode in
                        HStack(spacing: 5) {
                            Text(episode.episode)
                                .fontWeight(.bold)
                            Text(episode.name)
                            Text("(\(episode.air_date))")
                        }
                    }
                }
            }
        }
        .padding()
        .alert(errorText, isPresented: $showErrorAlert) {
            Button("Ok") {}
        }
        .onAppear {
            getEpisodes()
        }
    }
    
    func getEpisodes() {
        
        for episode in character.episode {
            //Building the API URL
            guard let url = URL(string: episode) else {
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
                            episodes.append(parseEpisode(data: data!))
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
}
