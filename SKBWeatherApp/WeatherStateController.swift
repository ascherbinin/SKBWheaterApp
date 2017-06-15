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
//    private(set) var currentWeather: Weather = {
//        if let items = NSKeyedUnarchiver.unarchiveObject(withFile: itemsFilePath) as? [ToDoItem] {
//            return items
//        }
//        else {
//            return Weather()
//        }
//    
//    }()
    
    
    func getCurrentWheather(lattitude: Double, longitude: Double) -> Void {
        Alamofire.request(URLs().getWeatherByCoordRequestUrl(latitude: lattitude, longitude: longitude), method: .get).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let newWeather = Weather()
                let json = JSON(value)
                print("JSON: \(json)")
                
                if let temp = json["main"]["temp"].float {
                    newWeather.temperature = temp
                } else {
                    //Print the error
                    print(json["user"]["id"])
                }
                
                if let cityName = json["name"].string {
                    newWeather.cityName = cityName
                }
                else {
                    //Print the error
                    print(json["name"])
                }
                
                if let countryName = json["sys"]["country"].string {
                    newWeather.countryName = countryName
                }
                else {
                    //Print the error
                    print(json["sys"]["country"])
                }
                
                if let lon = json["coord"]["lon"].float {
                    newWeather.lon = lon
                }
                else {
                    //Print the error
                    print(json["coord"]["lon"])
                }
                
                if let lat = json["coord"]["lat"].float {
                    newWeather.lat = lat
                }
                else {
                    //Print the error
                    print(json["coord"]["lat"])
                }
                
                if let weatherFields = json["weather"].array {
                    for field in weatherFields {
                        if let weatherID = field["id"].int {
                            newWeather.weatherId = Int16(weatherID)
                        }
                        else {
                            print(field["id"])
                        }
                        
                        if let weatherTitle = field["main"].string {
                            newWeather.weatherTitle = weatherTitle
                        }
                        else {
                            print(field["main"])
                        }
                        
                        if let weatherDescription = field["description"].string {
                            newWeather.weatherDescription = weatherDescription
                        }
                        else {
                            print(field["description"])
                        }
                        
                        if let weatherIcon = field["icon"].string {
                            newWeather.iconName = weatherIcon
                        }
                        else {
                            print(field["icon"])
                        }
                    }
                }
                
                if let clouds = json["clouds"]["all"].int {
                    newWeather.clouds = Int16(clouds)
                }
                else {
                    //Print the error
                    print(json["clouds"]["all"])
                }
                
                if let windSpeed = json["wind"]["speed"].float {
                    newWeather.windSpeed = windSpeed
                }
                else {
                    //Print the error
                    print(json["wind"]["speed"])
                }
                
                if let windDeg = json["wind"]["deg"].int {
                    newWeather.windDeg = Int16(windDeg)
                }
                else {
                    //Print the error
                    print(json["wind"]["deg"])
                }
                
                newWeather.dt = NSDate()

                self.save()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addItem(itemName: String, itemDescription: String?)
    {
        // Direct add item to db
    }
    
    
    
    func getLastWeather() {
        let weathers = DBManager.instance.fetchRequest(entityName: "Weather", keyForSort: "dt") as! [Weather]
        print (weathers)
    }
    
    func save() {
        DBManager.instance.saveContext()
    }
}
