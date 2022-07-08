//
//  WeatherTableViewCell.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import UIKit
import Hero
import Combine

class WeatherTableViewCell: UITableViewCell {
    
    static let cellIdentifier: String = "WeatherTableViewCell"

    private var iconObserver: AnyCancellable?
    
    let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    let gradientView: GradientView = {
        let v = GradientView()
        v.diagonalMode = true
        v.startColor = (UIColor(named: "background") ?? .black).withAlphaComponent(1)
        v.startLocation = 0
        v.endLocation = 0.5
        v.diagonalMode = false
        v.horizontalMode = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabelAttributes: [NSAttributedString.Key: Any] = [
      .strokeColor : UIColor.black,
      .foregroundColor : UIColor.white,
      .strokeWidth : -2.0,
      .font : UIFont(name: "Optima-ExtraBlack", size: 40) ?? UIFont.systemFont(ofSize: 40)
    ]
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempLabelAttributes: [NSAttributedString.Key: Any] = [
      .strokeColor : UIColor.black,
      .foregroundColor : UIColor.white,
      .strokeWidth : -2.0,
      .font : UIFont.boldSystemFont(ofSize: 30)
    ]
    
    let labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return iv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(containerView)
        containerView.constraintToEdges(to: self, constants: UIEdgeInsets(top: 10, left: -10, bottom: -10, right: 10))
        
        containerView.addSubview(backgroundImageView)
        backgroundImageView.constraintToEdges(to: containerView)
        
        
        containerView.addSubview(gradientView)
        gradientView.constraintToEdges(to: containerView)
        
        containerView.addSubview(labelStack)
        containerView.addSubview(icon)
        
        backgroundImageView.layer.cornerRadius = 30
        backgroundImageView.clipsToBounds = true
        containerView.clipsToBounds = true
        
        labelStack.addArrangedSubview(nameLabel)
        labelStack.addArrangedSubview(tempLabel)
        labelStack.addArrangedSubview(makeIconView())
        
        
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            labelStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            labelStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 200),
//            icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -20),
//            icon.topAnchor.constraint(equalTo: labelStack.bottomAnchor, constant: -20),
        ])
        
        isHeroEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(city: City) {
        let cityName = city.name
        let temp = city.weather?.main?.temp
        let image = UIImage(named: cityName.components(separatedBy: .whitespacesAndNewlines).joined().lowercased())
        backgroundImageView.image = image
        nameLabel.attributedText = NSMutableAttributedString(string: cityName, attributes: nameLabelAttributes)
        let tempString = temp != nil ? "\(Int(temp ?? 0.0))º C" : "Loading..."
        tempLabel.attributedText = NSMutableAttributedString(string: tempString, attributes: tempLabelAttributes)
        
        isHeroEnabled = true
        containerView.heroID = "\(cityName) container"
        backgroundImageView.heroID = "\(cityName) image"
        nameLabel.heroID = "\(cityName) name"
        tempLabel.heroID = "\(cityName) condition"
        
        if let image = city.weatherIcon {
            self.icon.image = image
        } else {
            iconObserver = city.weatherIconNotifier
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] image in
                    self?.icon.image = image
                })
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}

}


extension WeatherTableViewCell {
    private func makeIconView() -> UIView{
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.addSubview(icon)
        v.heightAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
//        v.widthAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
        return v
    }
}
