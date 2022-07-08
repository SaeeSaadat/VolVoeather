//
//  City.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import UIKit
import Combine

class City {
    let name: String
    let lat: Float
    let lon: Float
    var weather: OpenWeatherModel?
    var forecast: [ForecastModelWrapper]?

    var weatherIcon: UIImage? {
        didSet {
            weatherIconNotifier.send(weatherIcon)
        }
    }
    var weatherIconNotifier = PassthroughSubject<UIImage?, Never>()
    
    private var observer: [AnyCancellable] = []
    
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

extension City {
    func fetchData() -> Future<City, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            do {
                try NetworkManager.getRequest(url: "\(Constants.openWeatherURL)?lat=\(self.lat)&lon=\(self.lon)&units=metric&appid=\(Constants.appID)")
                    .sink( receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            promise(.failure(error))
                        case .finished:
                            print("city \(self.name) data fetched successfully!")
                        }
                    }, receiveValue: { [weak self] (data, response) in
                        guard let self = self else { return }
                        let decoder = JSONDecoder()
                        do {
                            let weather = try decoder.decode(OpenWeatherModel.self, from: data)
                            self.weather = weather
                            self.fetchWeatherIcon()
                            promise(.success(self))
                        } catch (let err) {
                            print("Exception occured while decoding response!")
                            promise(.failure(err))
                        }
                    }).store(in: &self.observer)
            } catch(let error) {
                promise(.failure(error))
            }
        }
    }
    
    func fetchWeatherIcon(iconID: String? = nil) {
        // TODO: cache icons using coreData
        guard let iconName = iconID ?? self.weather?.weather[0]?.icon else { return }
        do {
            try NetworkManager.getRequest(url: "\(Constants.openWeatherIconsURL)/\(iconName)@2x.png")
                .sink(receiveCompletion: { completion in
                    if case .failure(let err) = completion {
                        self.weatherIcon = UIImage(systemName: "xmark.icloud")
                        print("failure occured while fetching weather icon: \(err)")
                    }
                }, receiveValue: { (data: Data, response: URLResponse) in
                    if let image = UIImage(data: data) {
                        self.weatherIcon = image
                    }
                }).store(in: &observer)
        } catch (let err){
            self.weatherIcon = UIImage(systemName: "xmark.icloud")
            print("error occured while fetching weather icon: \(err)")
        }
    }
    
    func fetchForecast() -> Future<[ForecastModelWrapper]?, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            do {
                try NetworkManager.getRequest(url: "\(Constants.openWeatherForecastURL)?lat=\(self.lat)&lon=\(self.lon)&units=metric&appid=\(Constants.appID)")
                    .sink( receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            promise(.failure(error))
                        case .finished:
                            print("city \(self.name) data fetched successfully!")
                        }
                    }, receiveValue: { [weak self] (data, response) in
                        guard let self = self else { return }
                        let decoder = JSONDecoder()
                        do {
                            let forecast = try decoder.decode(OpenWeatherForecastModel.self, from: data)
                            self.forecast = forecast.list?.map({ forecastModel in
                                return ForecastModelWrapper(forecast: forecastModel)
                            })
                            for f in self.forecast ?? [] {
                                self.fetchForecastIcon(forecast: f, iconID: f.forecast.weather?[0].icon)
                            }
                            
                            promise(.success(self.forecast))
                        } catch (let err) {
                            print("Exception occured while decoding forecast response!")
                            print(err)
                            promise(.failure(err))
                        }
                    }).store(in: &self.observer)
            } catch(let error) {
                promise(.failure(error))
            }
        }
    }
    
    func fetchForecastIcon(forecast: ForecastModelWrapper, iconID: String?) {
        // TODO: cache icons using coreData
        guard let iconID = iconID else {
            return
        }

        do {
            try NetworkManager.getRequest(url: "\(Constants.openWeatherIconsURL)/\(iconID)@2x.png")
                .sink(receiveCompletion: { completion in
                    if case .failure(let err) = completion {
                        self.weatherIcon = UIImage(systemName: "xmark.icloud")
                        print("failure occured while fetching weather icon: \(err)")
                    }
                }, receiveValue: { (data: Data, response: URLResponse) in
                    if let image = UIImage(data: data) {
                        forecast.weatherIcon = image
                    }
                }).store(in: &observer)
        } catch (let err){
            self.weatherIcon = UIImage(systemName: "xmark.icloud")
            print("error occured while fetching weather icon: \(err)")
        }
    }
    
}
