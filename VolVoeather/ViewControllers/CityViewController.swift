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
    
    var model: City?
    var observer: [AnyCancellable] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        conditionLabel.text = "\(model.weather?.main?.temp ?? 0)"
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
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
