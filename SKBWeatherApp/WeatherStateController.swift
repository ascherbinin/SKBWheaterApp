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
import CoreData

protocol WeatherStateProtocol {
    func didGetNewWeather(newWeather: Weather?)
    func errorRequest(errorMsg: String)
}

class WeatherStateController: NSObject, LocationServiceDelegate, UNUserNotificationCenterDelegate
{
    var delegate: WeatherStateProtocol?
    var frc = DBManager.sharedInstance.fetchedResultsController(entityName: "Weather", keyForSort: "dt", ascending: false)
    
    var currentWeather: Weather? {
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
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        Alamofire.request(URLs().getWeatherByCoordRequestUrl(latitude: latitude, longitude: longitude), method: .get).validate().responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let newWeather = Weather()
                    var needNotify = false
                    let json = JSON(value)
                    let lastTemp = self.getLastWeather()?.temperature
                    print("JSON: \(json)")
                    
                    if let temp = json["main"]["temp"].float {
                        newWeather.temperature = temp
                        //newWeather.temperature = 10
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
                    if (lastTemp != nil &&
                        lastTemp! - newWeather.temperature >= 3)
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
    
    func deleteObjectAtPath(indexPath: IndexPath) {
        let object = frc.object(at: indexPath) as! NSManagedObject
        frc.managedObjectContext.delete(object)
        DBManager.sharedInstance.saveContext()
    }
    
    func getLastWeather() -> Weather? {
        if let weathers = DBManager.sharedInstance.fetchRequest(entityName: "Weather", keyForSort: "dt") as? [Weather] {
            return weathers.count > 0 ? weathers[0] : nil
        }
        else {
           return nil
        }
    }
    
    func save() {
        DBManager.sharedInstance.saveContext()
    }
    
    // MARK: LocationServiceDelegate
    
    func tracingLocation(curLocation: CLLocation) {
        //print ("Location: Long: \(curLocation.coordinate.longitude) Lat: \(curLocation.coordinate.latitude)")
        if (!isLoading) {
            isLoading = true;
            getCurrentWeather(latitude: curLocation.coordinate.latitude, longitude: curLocation.coordinate.longitude,
            handleComplete: {isColdy in
                self.delegate?.didGetNewWeather(newWeather: self.getLastWeather())
                if (isColdy) {
                    self.createNotification()
                }
                self.isLoading = false
            }) {error in
                self.delegate?.errorRequest(errorMsg: error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        self.delegate?.errorRequest(errorMsg: loc("ERROR_GEOLOCATION_MESSAGE") + " \(error.localizedDescription)")
    }
    
    func startGetLocation(){
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "notification":
            print("Action First Tapped")
        default:
            break
        }
        completionHandler()
    }

    
    func createNotification ()
    {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            let requestIdentifier = "coldNotification"
            content.title = loc("NOTIFY_COLDY_TITLE")
            content.body = loc("NOTIFY_COLDY_MESSAGE")
            content.categoryIdentifier = "notifyCategory"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        } else {
            let localNotification = UILocalNotification()
            localNotification.fireDate = Date(timeIntervalSinceNow: 1)
            localNotification.alertBody = loc("NOTIFY_COLDY_MESSAGE")
            localNotification.timeZone = NSTimeZone.default
            
            //set the notification
            UIApplication.shared.presentLocalNotificationNow(localNotification)
        }
    }
}
