//
//  Functions.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import Foundation

//Parse the page info
func parsePageInfo(data : Data) -> PageInfo {
    var pageInfo : PageInfo = PageInfo()
    
    do {
        //Parsing the results
        pageInfo = try JSONDecoder().decode(PageInfo.self, from: data)
    } catch {
        print("An error has occurred: \(error)")
    }
    
    return pageInfo
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
