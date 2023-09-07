//
//  EpisodeRow.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import SwiftUI

struct EpisodeRow : View {
    
    var episode : Episode
    
    var body: some View {
        HStack(spacing: 7) {
            Text(episode.episode)
                .fontWeight(.bold)
            Text(episode.name)
            Text("(\(episode.air_date))")
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 10)
    }
}
