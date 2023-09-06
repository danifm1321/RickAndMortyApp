//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import Foundation

struct Episode : Hashable, Codable, Identifiable {
    var id : Int64?
    var name : String = ""
    var air_date : String = ""
    var episode : String = ""
    var characters : [String] = []
    var url : String = ""
    var created : String = ""
}
