//
//  OpenWeatherModels.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/8/22.
//

import UIKit
import Combine

struct OWWeather: Decodable {
    let dt: Int?
    let id: Int?
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

struct OpenWeatherForecastModel: Decodable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [OWForecastModel]?
}

struct OWForecastModel: Decodable {
    let dt: Double?
    let main: OWMain?
    let weather: [OWWeather]?
    let clouds: OWClouds?
    let wind: OWWind?
    let visibility: Int?
}

class ForecastModelWrapper {
    var forecast: OWForecastModel
    
    var weatherIcon: UIImage? {
        didSet {
            weatherIconNotifier.send(weatherIcon)
        }
    }
    var weatherIconNotifier = PassthroughSubject<UIImage?, Never>()
    
    init(forecast: OWForecastModel) {
        self.forecast = forecast
    }
}
