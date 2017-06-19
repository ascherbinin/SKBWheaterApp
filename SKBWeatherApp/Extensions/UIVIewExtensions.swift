//
//  UIVIewExtensions.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 13.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, color.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addGradient(startColor: UIColor, endColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [startColor, endColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
  
}
