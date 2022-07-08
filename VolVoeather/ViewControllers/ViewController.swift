//
//  ViewController.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import UIKit
import Hero
import Combine


class ViewController: UIViewController {

    private let cities = City.getAllCities()
    private var observer: [AnyCancellable] = []
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.cellIdentifier)
        tv.separatorStyle = .none
        return tv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.lightText, .font: UIFont.boldSystemFont(ofSize: 20)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "Weather"
        view.backgroundColor = UIColor(named: "background") ?? .black
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.constraintToEdges(to: view, constants: UIEdgeInsets(top: 90, left: -20, bottom: -10, right: 20))
        tableView.delegate = self
        tableView.dataSource = self
        
        self.isHeroEnabled = true
        fetchCityData()
    }
    

    private func fetchCityData() {
        for city in cities {
            do {
                try NetworkManager.getRequest(url: "\(Constants.openWeatherURL)?lat=\(city.lat)&lon=\(city.lon)&units=metric&appid=\(Constants.appID)")
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            print("error! \(error)")
                        case .finished:
                            print("Finished! yeay!")
                        }
                    } receiveValue: { [weak self] (data, response) in
                        guard let self = self else { return }
                        let decoder = JSONDecoder()
                        do {
                            let weather = try decoder.decode(OpenWeatherModel.self, from: data)
                            city.weather = weather
                            self.tableView.reloadData()
                        } catch {
                            print("Exception occured while decoding response!")
                        }
                        
                    }.store(in: &observer)
            } catch {
                print("Exception occured!")
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellIdentifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        let city = cities[indexPath.row]
        cell.setupCell(cityName: city.name, temp: city.weather?.main?.temp)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = cities[indexPath.row]
        let storyboard = UIStoryboard(name: "CityStoryboard", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CityViewController") as? CityViewController else { return }
        vc.model = model
        self.isHeroEnabled = true
        navigationController?.isHeroEnabled = true
        navigationController?.heroNavigationAnimationType = .autoReverse(presenting: .auto)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
