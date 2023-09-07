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
                if let url = URL(string: character.image) {
                    descargarImagenDesdeURL(url) { (imagen) in
                        if let imagen = imagen {
                            // La imagen se ha descargado y almacenado en caché correctamente
                            self.cachedImage = imagen
                        } else {
                            // No se pudo descargar la imagen
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
    
    
    func descargarImagenDesdeURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        // Comprobar si la imagen está en la caché
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            if let image = UIImage(data: cachedResponse.data) {
                completion(image)
                return
            }
        }
        
        // Si la imagen no está en la caché, la descargamos
        let session = URLSession.shared
        let tarea = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error al descargar la imagen: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // Almacenar la imagen en la caché
                let cachedData = CachedURLResponse(response: response!, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
                
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        tarea.resume()
    }
}
