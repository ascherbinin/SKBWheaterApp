//
//  BackgroundView.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 13.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import Foundation
import UIKit

class BackgroundView: UIView {
   
    var startColor: UIColor = UIColor.blue
    var endColor: UIColor = UIColor.lightGray

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let colorLocations:[CGFloat] = [0.0, 0.25, 0.75, 1.0]
        
        let colors = [Colors.myLightBlue.cgColor,
                      Colors.myBlue.cgColor,
                      Colors.myBlueLight.cgColor,
                      Colors.myDarkBlue.cgColor]
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorsSpace: colorspace,
                                  colors: colors as CFArray, locations: colorLocations)
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:self.bounds.height)

        
        context?.drawLinearGradient(gradient!,
                                    start: startPoint, end: endPoint, 
                                    options: .drawsBeforeStartLocation)
        

    }
    
    
    
}
