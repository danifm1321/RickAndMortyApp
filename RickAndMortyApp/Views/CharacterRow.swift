//
//  CharacterRow.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import SwiftUI

struct CharacterRow : View {
    
    var character : RickAndMortyCharacter
    @State private var cachedImage: UIImage? = nil

    
    var body: some View {
        HStack {
            
            ZStack {
                //Show the cached image
                if let image = cachedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    //Default image if something didn't work
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                }
            }
            .frame(width: 200, height: 200)
            .onAppear {
                
                //Getting the image
                if let url = URL(string: character.image) {
                    downloadImages(url: url) { image in
                        if let image = image {
                            self.cachedImage = image
                        } else {
                            print("Can't download the image")
                        }
                    }
                }
            }
            
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
            }
            .padding()
        }
    }
    
    
    func downloadImages(url: URL, completion: @escaping (UIImage?) -> Void) {
        //Check if the image is already cached
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            if let image = UIImage(data: cachedResponse.data) {
                completion(image)
                return
            }
        }
        
        //Download the image
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error downloading the image: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                //Store the image in cache
                let cachedData = CachedURLResponse(response: response!, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
                
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}
