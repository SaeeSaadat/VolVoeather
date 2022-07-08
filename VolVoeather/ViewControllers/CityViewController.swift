//
//  CityViewController.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import UIKit
import Combine

class CityViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var iconImageVIew: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    
    var model: City?
    var observer: [AnyCancellable] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = model else {
            fatalError("Must set model before loading vc")
        }
        isHeroEnabled = true
        for v in contentView.subviews {
            v.heroID = "\(model.name) \(v.heroID ?? "")"
        }
        
        let image = UIImage(named: model.name.components(separatedBy: .whitespacesAndNewlines).joined().lowercased())
        cityImageView.image = image
        cityImageView.layer.cornerRadius = 15
        cityImageView.clipsToBounds = true
        nameLabel.text = model.name
        setCondition()
        setIcon()
        let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
        setTime()
        setupTable()
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.reuseIdentifier)
        
        model?.fetchForecast()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Error while fetching forecast: \(err)")
                }
            }, receiveValue: { [weak self] forecast in
                self?.tableView.reloadData()
            }).store(in: &observer)
    }
    
    private func setIcon() {
        guard let model = model else { return }
        if let image = model.weatherIcon {
            self.iconImageVIew.image = image
        } else {
            model.weatherIconNotifier
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] image in
                    self?.iconImageVIew.image = image
                    self?.setTime()
                    self?.setCondition()
                }).store(in: &observer)
        }
    }
    
    @objc private func setTime() {
        guard let tznumber = model?.weather?.timezone else {
            timeLabel.isHidden = true
            return
        }
        let tz = TimeZone(secondsFromGMT: tznumber)
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        f.locale = Locale(identifier: "EN_US_POSIX")
        f.timeZone = tz
        timeLabel.text = f.string(from: Date())
    }
    
    private func setCondition() {
        conditionLabel.text = "\(Int(model?.weather?.main?.temp ?? 0))º C"
    }
    
    func fetchData() {
        guard let model = model else {
            return
        }
        
        do {
            try NetworkManager.getRequest(url: "\(Constants.openWeatherURL)?lat=\(model.lat)&lon=\(model.lon)&units=metric&appid=\(Constants.appID)")
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
                    self.conditionLabel.text = "Done"
                    let decoder = JSONDecoder()
                    do {
                        let weather = try decoder.decode(OpenWeatherModel.self, from: data)
                        print(weather)
                    } catch {
                        print("Exception occured while decoding response!")
                    }
                    
                }.store(in: &observer)
        } catch {
            print("Exception occured!")
        }
        
        
    }
    
    
}


extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let c = model?.forecast?.count ?? 0
        tableViewHeightConstraint.constant = CGFloat(c) * ForecastTableViewCell.heightConstant
        return c
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let forecast = model?.forecast, forecast.count > 0 else {
            // empty table!
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseIdentifier) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(model: forecast[indexPath.row])
        return cell
        
    }
}
