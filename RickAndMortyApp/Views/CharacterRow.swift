//
//  CharacterRow.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import SwiftUI

struct CharacterRow : View {
    
    var character : Character
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: character.image)) { image in
                
                //Loaded image
                image
                    .resizable()

            } placeholder: {
                
                //Default image if something didn't work
                Image(systemName: "camera.circle.fill")
                    .resizable()
            }
            .frame(width: 200, height: 200)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    HStack {
                        //Dot that changes the color in function of the character status
                        Image(systemName: "circle.fill")
                            .if(character.status == "Alive", transform: {$0.foregroundColor(.green)})
                            .if(character.status == "Dead", transform: {$0.foregroundColor(.red)})
                            .foregroundColor(.gray)
                                
                        Text(character.status + " - " + character.species)
                    }
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
        }
    }
}
