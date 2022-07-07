//
//  CityViewController.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var iconImageVIew: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var model: City?
    
    
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
        nameLabel.text = model.name
        conditionLabel.text = model.weather?.condition

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
