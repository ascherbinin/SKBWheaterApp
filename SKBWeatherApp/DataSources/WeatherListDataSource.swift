//
//  WeatherListDataSource.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 20.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit

class WeatherListDataSource: NSObject {
    let stateController: WeatherStateController
    init(tableView: UITableView, stateController: WeatherStateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
    }
    
}

extension WeatherListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        if let sections = stateController.frc.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = stateController.frc.object(at: indexPath) as! Weather
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.temperature = "\(Int16(weather.temperature)) °C"
        cell.date = "\(weather.dt!.customFormatted)"
        cell.location = weather.cityName
        return cell
    }
    
}

