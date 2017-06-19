//
//  WeatherViewController.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 13.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit
import AlamofireImage

class WeatherViewController: UIViewController, WeatherStateProtocol
{


    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var ivWeatherIcon: UIImageView!
    @IBOutlet weak var lblWeatherTitle: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblClouds: UILabel!
    @IBOutlet weak var lblCloudsPercent: UILabel!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!

    var stateController: WeatherStateController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupNavigationControllerController()
        stateController?.delegate = self
        stateController?.startGetLocation()
        updateCurrentWeather(weather: (stateController?.currentWeather)!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    
    func setupNavigationControllerController()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "listImage"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WeatherViewController.showWheaterList))
        rightBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func showWheaterList() -> Void {
        print ("Show wheater!")
    }
    
    func updateCurrentWeather(weather: Weather) -> Void {
        lblDate.text = "Today: \(weather.dt!.customFormatted)"
        lblTemp.text = "\(Int16(weather.temperature)) °C"
        lblCurrentLocation.text = weather.cityName! + ", " + weather.countryName!
        lblWeatherTitle.text = weather.weatherTitle
        lblWindSpeed.text = "\(weather.windSpeed) m/sec"
        lblCloudsPercent.text = "\(weather.clouds) %"
        ivWeatherIcon.af_setImage(withURL: URL(string: URLs().getImageURL() + "\(weather.iconName!).png")!)
    }
    
    func didGetNewWeather(newWeather: Weather) {
         updateCurrentWeather(weather: (stateController?.currentWeather)!)
         aiLoading.stopAnimating()
    }

}
