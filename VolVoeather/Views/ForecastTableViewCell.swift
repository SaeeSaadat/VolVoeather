//
//  ForecastTableViewCell.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/8/22.
//

import UIKit
import Combine

class ForecastTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "forecastTableViewCell"
    static let heightConstant: CGFloat = 50
    
    var observer: [AnyCancellable] = []
    var model: ForecastModelWrapper?
    
    let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: ForecastTableViewCell.heightConstant).isActive = true
        iv.widthAnchor.constraint(equalToConstant: ForecastTableViewCell.heightConstant).isActive = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = UIColor(named: "textnt")
        l.text = "loading"
        return l
    }()
    
    
    let tempLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = UIColor(named: "textnt")
        l.text = "loading"
        return l
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(containerView)
        containerView.constraintToEdges(to: self)
        containerView.addSubview(nameLabel)
        containerView.addSubview(icon)
        containerView.addSubview(tempLabel)
        
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: ForecastTableViewCell.heightConstant),
            containerView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            containerView.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            containerView.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -10),
            containerView.trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: 10),
            containerView.centerXAnchor.constraint(equalTo: icon.centerXAnchor, constant: -20),
        ])
        
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        backgroundColor = .clear
        
    }
    
    func setupCell(model: ForecastModelWrapper) {
        
        guard let dt = model.forecast.dt else { return }
        let date = Date(timeIntervalSince1970: dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "YY/DD/MM HH:mm"
        formatter.locale = Locale(identifier: "EN_US_POSIX")
        
        
        self.nameLabel.text = formatter.string(from: date)
        self.tempLabel.text = "\(Int(model.forecast.main?.temp ?? 0.0))º C"
        
        
        if let image = model.weatherIcon {
            self.icon.image = image
        } else {
            model.weatherIconNotifier
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] image in
                    self?.icon.image = image
                }).store(in: &observer)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
