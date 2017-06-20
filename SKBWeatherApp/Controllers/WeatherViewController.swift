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
    @IBOutlet weak var btnRefresh: UIButton!

    var stateController: WeatherStateController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupNavigationControllerController()
        localize()
        stateController?.delegate = self
        stateController?.startGetLocation()
        if (stateController?.currentWeather) != nil {
            updateCurrentWeather(weather: (stateController?.currentWeather)!)
        }
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
        self.navigationController?.delegate = self as? UINavigationControllerDelegate
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "listImage"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WeatherViewController.showWheaterList))
        rightBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func showWheaterList() -> Void {
        let weathersVC = WeathersListViewController()
        weathersVC.stateController = stateController;
        self.navigationController?.push(viewController: weathersVC, transitionType: kCATransitionMoveIn, duration: 0.4)
    }
    
    func updateCurrentWeather(weather: Weather) -> Void {
        if let date = weather.dt?.customFormatted {
            lblDate.text = loc("DATE_FIELD") + " \(date)"
        }
        
        lblTemp.fadeTransitionWithText(0.5, text: "\(Int16(weather.temperature)) °C")
        lblCurrentLocation.text = weather.cityName! + ", " + weather.countryName!
        lblWeatherTitle.text = weather.weatherTitle
        lblWindSpeed.text = "\(weather.windSpeed) " + loc("WIND_VALUE_FIELD")
        lblCloudsPercent.text = "\(weather.clouds) %"
        ivWeatherIcon.af_setImage(withURL: URL(string: URLs().getImageURL() + "\(weather.iconName!).png")!)
    }
    
    func didGetNewWeather(newWeather: Weather?) {
        if (newWeather != nil) {
            updateCurrentWeather(weather: (stateController?.currentWeather)!)
            aiLoading.stopAnimating()
        }
    }
    
    func errorRequest(errorMsg: String) {
        self.view.makeToast(errorMsg)
        aiLoading.stopAnimating()
    }
    

    @IBAction func onClickRefresh(_ sender: Any) {
        aiLoading.startAnimating()
        stateController?.startGetLocation()
    }
    
    func localize()
    {
        lblWind.text = loc("WIND_FIELD")
        lblClouds.text = loc("CLOUDS_FIELD")
    }
}
