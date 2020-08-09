//
//  ObjectsBrain.swift
//  ARDicee
//
//  Created by Tyler Nevell on 8/9/20.
//  Copyright © 2020 Tyler Nevell. All rights reserved.
//

import Foundation

// so many potentials bugs from this hastily put together solution
struct ObjectsBrain {
    let objects = [
        "Bridge" : "Bridge.scn",
        "Skyscraper" : "SkyScraper.scn",
        "Tram" : "Tram.scn",
        "Dual Carriage Way" : "Dual Carriage Way.scn",
        "Home" : "House.scn",
        "Park" : "Park and Subway.scn",
        "Single Carriage Way" : "Single Carriage Way.scn",
        "Metro" : "Park and Subway.scn",
        "" : "Tram.scn"
    ]
    
    // bruh, y u do dis
    // might crash if we find nothing
    let denizGaveMeExtraWork = [
        "Bridge" : "Column001",
        "Skyscraper" : "Box342",
        "Tram" : "Box197",
        "Dual Carriage Way" : "Box197",
        "Home" : "Box001",
        "Park" : "Ground",
        "Single Carriage Way" : "Box197",
        "Metro" : "Ground"
    ]
    
    
    func get_objectFileName(_ choice: String) -> String {
        // pass in string, look for it in dictionary, return it
        print(choice)
        print(objects[choice]!)
        return objects[choice]!
    }
    
    func get_theName(_ choice: String) -> String {
        return denizGaveMeExtraWork[choice]!
    }
    
}
