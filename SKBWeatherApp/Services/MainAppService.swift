//
//  MainAppService.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 13.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit

class MainAppService : NSObject, UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        appDelegate().window = UIWindow(frame: UIScreen.main.bounds)
        showWeatherVC()
        appDelegate().window?.makeKeyAndVisible()
        
        return true
    }
    
    func showWeatherVC() {
        let weatherVC = WeatherViewController()
        let navC = UINavigationController(rootViewController: weatherVC)
        appDelegate().window?.rootViewController = navC
    }

 
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

}
