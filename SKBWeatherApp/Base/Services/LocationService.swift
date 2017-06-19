//
//  LocationService.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 19.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit
import CoreLocation

//protocol LocationServiceDelegate {
//    func tracingLocation(curLocation: CLLocation)
//    func tracingLocationDidFailWithError(error: Error)
//}

class LocationService: NSObject, UIApplicationDelegate, CLLocationManagerDelegate {
    
//    static let sharedInstance = LocationService()
//    private override init() {
//        super.init()
//        
//        self.locationManager = CLLocationManager()
//        guard let locationManager = self.locationManager else {
//            return
//        }
//        
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            // you have 2 choice
//            // 1. requestAlwaysAuthorization
//            // 2. requestWhenInUseAuthorization
//            locationManager.requestAlwaysAuthorization()
//        }
//        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
//        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
//        locationManager.delegate = self
//    } //This prevents others from using the default '()' initializer for this class.

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        getCurrentWeather()
        return true
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last location
        self.lastLocation = location
        let locDict: [String : Double] = ["lat":location.coordinate.latitude, "lon": location.coordinate.longitude]
        UserDefaults.standard.set(locDict, forKey: "location")

        // use for real time update location
        //updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        //updateLocationDidFailWithError(error: error)
    }
    
    func getCurrentWeather()
    {
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }

        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
        
        startUpdatingLocation()
    }
    
//    // Private function
//    private func updateLocation(currentLocation: CLLocation){
//        
//        guard let delegate = self.delegate else {
//            return
//        }
//        
//        //delegate.tracingLocation(curLocation: currentLocation)
//    }
//    
//    private func updateLocationDidFailWithError(error: Error) {
//        
//        guard let delegate = self.delegate else {
//            return
//        }
//        
//        //delegate.tracingLocationDidFailWithError(error: error)
//    }
}
