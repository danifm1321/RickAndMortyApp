//
//  PageInfo.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 7/9/23.
//

import Foundation

struct PageInfo : Codable, Hashable {
    var info : Info = Info()
    var results : [RickAndMortyCharacter] = []
}
