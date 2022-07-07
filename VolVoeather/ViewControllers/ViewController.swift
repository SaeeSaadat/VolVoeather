//
//  ViewController.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import UIKit
import Hero

class ViewController: UIViewController {

    private let cities = City.getAllCities()
    
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
        cell.setupCell(cityName: city.name, temp: city.weather?.temp)
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
