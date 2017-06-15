//
//  WeatherStateController.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 15.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class WeatherStateController
{
    private let mainApiURL = "http://api.openweathermap.org/data/2.5/"
    private let currentWheaterURL = "weather";
    private let apiKey = "&appid=249debd02da485df26d56c612c40cf33";
    
    func getCurrentWheather(lattitude: Double, longitude: Double) -> Void {
        let weatherURL = URLs().getWeatherByCoordRequestUrl(latitude: lattitude, longitude: longitude)
        Alamofire.request(weatherURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
