//
//  WeatherTableViewCell.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import UIKit
import Hero

class WeatherTableViewCell: UITableViewCell {
    
    static let cellIdentifier: String = "WeatherTableViewCell"

    let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
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
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
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
        
        backgroundImageView.addBlurView(blurStyle: .dark)
        containerView.addSubview(labelStack)
        
        backgroundImageView.layer.cornerRadius = 30
        backgroundImageView.clipsToBounds = true
        containerView.clipsToBounds = true
        
        labelStack.addArrangedSubview(nameLabel)
        labelStack.addArrangedSubview(tempLabel)
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            labelStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        isHeroEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(cityName: String, temp: Float?) {
        let image = UIImage(named: cityName.components(separatedBy: .whitespacesAndNewlines).joined().lowercased())
        backgroundImageView.image = image
        nameLabel.attributedText = NSMutableAttributedString(string: cityName, attributes: nameLabelAttributes)
        let tempString = temp != nil ? "\(temp ?? 0.0)º C" : "28º C"
        tempLabel.attributedText = NSMutableAttributedString(string: tempString, attributes: tempLabelAttributes)
        
        isHeroEnabled = true
        containerView.heroID = "\(cityName) container"
        backgroundImageView.heroID = "\(cityName) image"
        nameLabel.heroID = "\(cityName) name"
        tempLabel.heroID = "\(cityName) condition"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}

}
