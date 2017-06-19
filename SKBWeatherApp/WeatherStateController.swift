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
import CoreLocation

protocol WeatherStateProtocol {
    func didGetNewWeather(newWeather: Weather)
}

class WeatherStateController
{
    var delegate: WeatherStateProtocol?
    
    var currentWeather: Weather {
        get {
            return getLastWeather()
        }
    }
    
    
    var loading: Bool = false
    
    var isLoading: Bool {
        set {
            self.loading = newValue
        }
        get {
            return self.loading
        }
    }
    
    func getCurrentWeather(latitude: Double,
                           longitude: Double,
                           handleComplete:@escaping ()->(),
                           handleError:@escaping ()->()) {
        isLoading = true;
        Alamofire.request(URLs().getWeatherByCoordRequestUrl(latitude: latitude, longitude: longitude), method: .get).validate().responseJSON {
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
                    self.isLoading = false
                    handleComplete()
                case .failure(let error):
                    self.isLoading = false
                    print(error)
                    handleError()
                }
        }
    }
    
    func addItem(itemName: String, itemDescription: String?)
    {
        // Direct add item to db
    }
    
    
    
    func getLastWeather() -> Weather {
        if let weathers = DBManager.instance.fetchRequest(entityName: "Weather", keyForSort: "dt") as? [Weather] {
            return weathers[0]
        }
        else {
           return Weather()
        }
    }
    
    func save() {
        DBManager.instance.saveContext()
    }
    
    func getCurrentLocation()
    {
        if (!isLoading) {
            isLoading = true;
            if let result = UserDefaults.standard.value(forKey: "locDict") {
                print(result)
            }
//            getCurrentWeather(latitude: locationDict["lat"],
//            longitude: locationDict["lon"],
//            handleComplete: {
//                self.delegate?.didGetNewWeather(newWeather: self.getLastWeather())
//            }) {
//                print ("Error");
//            }
        }
    }
    
//    // MARK: LocationServiceDelegate
//    
//    func tracingLocation(curLocation: CLLocation) {
//        print ("Location: Long: \(curLocation.coordinate.longitude) Lat: \(curLocation.coordinate.latitude)")
//        if (!isLoading) {
//            isLoading = true;
//            getCurrentWeather(latitude: curLocation.coordinate.latitude, longitude: curLocation.coordinate.longitude,
//            handleComplete: {
//                self.delegate?.didGetNewWeather(newWeather: self.getLastWeather())
//            }) { 
//                print ("Error");
//            }
//        }
//    }
//    
//    func tracingLocationDidFailWithError(error: Error) {
//        print ("error: \(error)");
//    }
//    
//    func startGetLocation(){
//        LocationService.sharedInstance.delegate = self
//        LocationService.sharedInstance.startUpdatingLocation()
//    }
}
