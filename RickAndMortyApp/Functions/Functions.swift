//
//  Functions.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import Foundation

//Parse a list of characters
func parseCharacterList(data : Data) -> [Character] {
    var characters : [Character] = []
    
    do {
        //Getting the JSON as an object
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        //Getting only the results of the JSON
        if let jsonObject = json as? [String: Any], let results = jsonObject["results"] as? [[String: Any]] {
           
            //Parsing only the results
            let jsonData = try JSONSerialization.data(withJSONObject: results, options: [])
            characters = try JSONDecoder().decode([Character].self, from: jsonData)
            
        } else {
            print("An error has occurred: 'results' not found.")
        }
    } catch {
        print("An error has occurred: \(error)")
    }
    
    return characters
}


//Parse a list of episodes
func parseEpisode(data : Data) -> Episode {
    var episodes : Episode = Episode()
    
    do {
        //Parsing the results
        episodes = try JSONDecoder().decode(Episode.self, from: data)
    } catch {
        print("An error has occurred: \(error)")
    }
    
    return episodes
}
