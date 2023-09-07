//
//  Info.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 7/9/23.
//

import Foundation

struct Info : Codable, Hashable {
    var count : Int = 0
    var pages : Int = 0
    var next : String? = nil
    var prev : String? = nil
}
