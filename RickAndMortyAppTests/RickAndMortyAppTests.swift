//
//  RickAndMortyAppTests.swift
//  RickAndMortyAppTests
//
//  Created by IT DEV ES on 7/9/23.
//

import XCTest
@testable import RickAndMortyApp

final class RickAndMortyAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsePageInfo() {
        
        //JSON example from the API's docs
        let jsonPageInfo = """
        {
          "info": {
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character/?page=2",
            "prev": null
          },
          "results": [
            {
              "id": 1,
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "location": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/20"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
              ],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            }
          ]
        }
        """
        
        let info = Info(count: 826, pages: 42, next: "https://rickandmortyapi.com/api/character/?page=2", prev: nil)
        let results = [Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: Origin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"), location: Location(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/2"], url: "https://rickandmortyapi.com/api/character/1", created: "2017-11-04T18:48:46.250Z")]
        
        let pageInfo = PageInfo(info: info, results: results)
        
        if let jsonData = jsonPageInfo.data(using: .utf8) {
            let resultado = parsePageInfo(data: jsonData)
            XCTAssertEqual(resultado, pageInfo, "JSON did not parse correctly")
        } else {
            XCTFail("Can't convert JSON into Data")
        }
    }
    
    func testParseEpisode() {
        let jsonEpisode = """
        {
            "id": 28,
            "name": "The Ricklantis Mixup",
            "air_date": "September 10, 2017",
            "episode": "S03E07",
            "characters": [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/2"
                ],
            "url": "https://rickandmortyapi.com/api/episode/28",
            "created": "2017-11-10T12:56:36.618Z"
        }
        """
        
        let episode = Episode(id: 28, name: "The Ricklantis Mixup", air_date: "September 10, 2017", episode: "S03E07", characters: ["https://rickandmortyapi.com/api/character/1", "https://rickandmortyapi.com/api/character/2"], url: "https://rickandmortyapi.com/api/episode/28", created: "2017-11-10T12:56:36.618Z")
        
        if let jsonData = jsonEpisode.data(using: .utf8) {
            let resultado = parseEpisode(data: jsonData)
            XCTAssertEqual(resultado, episode, "JSON did not parse correctly")
        } else {
            XCTFail("Can't convert JSON into Data")
        }
    }
}

