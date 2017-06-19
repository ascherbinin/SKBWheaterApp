//
//  WeatherListDelegate.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 20.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit

class WeatherListDelegate: NSObject {
    let stateController: WeatherStateController
    
    init(tableView: UITableView, stateController: WeatherStateController) {
        self.stateController = stateController
        super.init()
        tableView.delegate = self
    }
    
    
}

extension WeatherListDelegate: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(WeatherCell.height)
        
    }
}
