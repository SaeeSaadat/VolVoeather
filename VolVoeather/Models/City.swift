//
//  City.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import Foundation
import Combine

class City {
    let name: String
    let lat: Float
    let lon: Float
    var weather: OpenWeatherModel?
    
    init(name: String, lat: Float, lon: Float) {
        self.name = name
        self.lat = lat
        self.lon = lon
    }
    
    static let stockholm = City(name: "Stockholm", lat: 59.3293, lon: 18.0686)
    static let gothenburg = City(name: "Gothenburg", lat: 57.7089, lon: 11.9746)
    static let mountainView = City(name: "Mountain View", lat: 37.3861, lon: 122.0839)
    static let london = City(name: "London", lat: 51.5072, lon: 0.1276)
    static let newYork = City(name: "New York", lat: 40.7128, lon: 74.0060)
    static let berlin = City(name: "Berlin", lat: 52.5200, lon: 13.4050)
    static let tehran = City(name: "Tehran", lat: 35.7219, lon: 51.3347)
    
    static func getAllCities() -> [City] {
        return [stockholm, gothenburg, mountainView, london, newYork, berlin, tehran]
    }
}
