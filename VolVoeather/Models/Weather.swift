//
//  Weather.swift
//  VolVoeather
//
//  Created by Saee Saadat on 7/7/22.
//

import Foundation
struct Weather {
    let temp: Float
    
    var condition: String {
        get {
            return "\(temp)º C"
        }
    }
}
