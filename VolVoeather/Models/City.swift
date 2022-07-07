//
//  City.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import Foundation

class City {
    let name: String
    var weather: Weather?
    
    init(name: String) {
        self.name = name
    }
    
    static let stockholm = City(name: "Stockholm")
    static let gothenburg = City(name: "Gothenburg")
    static let mountainView = City(name: "Mountain View")
    static let london = City(name: "London")
    static let newYork = City(name: "New York")
    static let berlin = City(name: "Berlin")
    
    static func getAllCities() -> [City] {
        return [stockholm, gothenburg, mountainView, london, newYork, berlin]
    }
}
