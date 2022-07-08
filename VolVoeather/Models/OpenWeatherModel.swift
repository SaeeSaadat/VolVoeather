//
//  OpenWeatherModels.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/8/22.
//

import Foundation

struct OWWeather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct OWMain: Decodable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Float
    let humidity: Float
}

struct OWWind: Decodable {
    let speed: Float
    let deg: Float
}

struct OWClouds: Decodable{
    let all: Int
}

struct OpenWeatherModel: Decodable {
    let weather: [OWWeather?]
    let base: String?
    let main: OWMain?
    let visibility: Int?
    let wind: OWWind?
    let  clouds: OWClouds?
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
