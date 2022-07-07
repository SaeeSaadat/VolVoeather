//
//  AyotExtension+UIView.swift
//  Ayot-iOS-client
//
//  Created by Saee Saadat on 3/22/22.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult
    func constraintToEdges(to parentView: UIView, constants: UIEdgeInsets? = nil) -> (NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let top = self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: constants?.top ?? 0)
        let bottom = self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: constants?.bottom ?? 0)
        let leading = self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: constants?.right ?? 0)
        let trailing = self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: constants?.left ?? 0)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
        return (top, bottom, leading, trailing)
    }
    
    @discardableResult
    func addBlurView(layerIndex: Int = 0, blurStyle: UIBlurEffect.Style = .systemMaterial, blurAlpha: CGFloat = 0.5) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.insertSubview(blurEffectView, at: layerIndex)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.constraintToEdges(to: self)
        blurEffectView.alpha = blurAlpha
        return blurEffectView
    }
    
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.70
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize (width: 0, height: 5)
    }
}
