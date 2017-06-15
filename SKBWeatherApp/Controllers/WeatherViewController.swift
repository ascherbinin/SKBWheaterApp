//
//  WeatherViewController.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 13.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var vwBackground: UIView!
    
    let locationManager = CLLocationManager()
    var stateController: WeatherStateController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation();
        }
        
        setupNavigationControllerController()
        
        
        stateController?.getLastWeather()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }
    
    
    //this method is called by the framework on         locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did location updates is called")
        let userLocation = locations[0] as CLLocation
        print ("Location: Long: \(userLocation.coordinate.longitude) Lat: \(userLocation.coordinate.latitude)")
        stateController?.getCurrentWheather(lattitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        //store the user location here to firebase or somewhere
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
    func setupNavigationControllerController()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        //var image = UIImage(named: "listImage")
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "listImage"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WeatherViewController.showWheaterList))
        rightBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func showWheaterList() -> Void {
        print ("Show wheater!")
    }

}
