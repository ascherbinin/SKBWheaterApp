//
//  WeatherCell.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 19.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    
    static let identifier = "WeatherCell"
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    var date: String? {
        didSet {
            lblDate?.text = date
        }
    }
    
    var temperature: String?{
        didSet {
            lblTemperature?.text = temperature
        }
    }
    
    var location: String? {
        didSet {
            lblLocation?.text = location
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
