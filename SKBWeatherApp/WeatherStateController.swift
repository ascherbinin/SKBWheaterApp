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
import UserNotifications

protocol WeatherStateProtocol {
    func didGetNewWeather(newWeather: Weather)
    func notifyColdy()
}

class WeatherStateController: NSObject, LocationServiceDelegate, UNUserNotificationCenterDelegate
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
                           handleComplete:@escaping (_ isColdy: Bool)->(),
                           handleError:@escaping (_ error: Error)->()) {
        isLoading = true;
        UNUserNotificationCenter.current().delegate = self
        Alamofire.request(URLs().getWeatherByCoordRequestUrl(latitude: latitude, longitude: longitude), method: .get).validate().responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let newWeather = Weather()
                    var needNotify = false
                    let json = JSON(value)
                    let lastTemp = self.getLastWeather().temperature
                    print("JSON: \(json)")
                    
                    if let temp = json["main"]["temp"].float {
                        //newWeather.temperature = temp
                        newWeather.temperature = 10
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
                    print ("NEW TEMP: \(newWeather.temperature) LAST TEMP: \(lastTemp) DIF \(lastTemp - newWeather.temperature)")
                    if (lastTemp - newWeather.temperature >= 3)
                    {
                        needNotify = true
                    }
                    self.save()
                    
                    handleComplete(needNotify)
                case .failure(let error):
                    handleError(error)
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
    
    // MARK: LocationServiceDelegate
    
    func tracingLocation(curLocation: CLLocation) {
        print ("Location: Long: \(curLocation.coordinate.longitude) Lat: \(curLocation.coordinate.latitude)")
        if (!isLoading) {
            isLoading = true;
            getCurrentWeather(latitude: curLocation.coordinate.latitude, longitude: curLocation.coordinate.longitude,
            handleComplete: {isColdy in
                self.delegate?.didGetNewWeather(newWeather: self.getLastWeather())
                if (isColdy) {
                    self.showNotify()
                    //self.delegate?.notifyColdy()
                }
                self.isLoading = false
            }) {error in
                print (error)
                self.isLoading = false
                
            }
        }
    }
    
    func tracingLocationDidFailWithError(error: Error) {
       print ("error: \(error)");
    }
    
    func startGetLocation(){
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "notification":
            print("Action First Tapped")
        default:
            break
        }
        completionHandler()
    }

    
    func showNotify ()
    {
        let content = UNMutableNotificationContent()
        let requestIdentifier = "coldNotification"
        content.title = "Похолодало!"
        content.body = "Нужно одеться теплее!"
        content.categoryIdentifier = "notifyCategory"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    
}
