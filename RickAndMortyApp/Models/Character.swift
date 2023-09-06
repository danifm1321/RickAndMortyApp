//
//  Character.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import Foundation


struct Character : Codable, Hashable, Identifiable {
    var id : Int64?
    var name : String = ""
    var status : String = ""
    var species : String = ""
    var type : String = ""
    var gender : String = ""
    var origin : Origin = Origin()
    var location : Location = Location()
    var image : String = ""
    var episode : [String] = []
    var url : String = ""
    var created : String = ""
}
