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
    
    let errorView: UIView = {
        let v = GradientView()
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .black
        v.horizontalMode = false
        v.startColor = .black.withAlphaComponent(0.8)
        v.endColor = .black.withAlphaComponent(0.6)
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        let errLabel = UILabel()
        errLabel.translatesAutoresizingMaskIntoConstraints = false
        errLabel.text = "Fetching data failed, try again?"
        errLabel.textColor = .white
        errLabel.font = UIFont.boldSystemFont(ofSize: 20)
        errLabel.textAlignment = .center
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try Again", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.red, for: .normal)
        button.tag = 123321
        v.addSubview(errLabel)
        v.addSubview(button)
        
        NSLayoutConstraint.activate([
            v.heightAnchor.constraint(equalToConstant: 300),
            v.widthAnchor.constraint(equalToConstant: 300),
            errLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor),
            errLabel.trailingAnchor.constraint(equalTo: v.trailingAnchor),
            errLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: errLabel.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: errLabel.centerXAnchor),
//            button.widthAnchor.constraint(equalToConstant: 100),
//            button.heightAnchor.constraint(equalToConstant: 50),
//            button.bottomAnchor.constraint(equalTo: v.bottomAnchor)
        ])
        
        v.isHidden = true
        return v
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
        
        view.addSubview(errorView)
        errorView.isHidden = true
        if let b = errorView.viewWithTag(123321) as? UIButton {
            b.addTarget(self, action: #selector(fetchCityData), for: .touchUpInside)
        }
        errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.isHeroEnabled = true
        fetchCityData()
    }
    
    
    @objc private func fetchCityData() {
        if !errorView.isHidden {
            errorView.isHidden = true
            tableView.isUserInteractionEnabled = true
        }
        for city in cities {
            city.fetchData()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    if case .failure(let err) = completion {
                        print(err)
                        guard let self = self else { return }
                        self.errorView.isHidden = false
                        self.tableView.isUserInteractionEnabled = false
                        
                    }
                } receiveValue: { [weak self] city in
                    self?.tableView.reloadData()
                }.store(in: &observer)
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
        cell.setupCell(city: city)
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
