//
//  LocalNotificationService.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 19.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit
import UserNotifications


class LocalNotificationService : NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        initNotificationSetupCheck()
        
        return true
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
        
        //actions defination
        let action = UNNotificationAction(identifier: "notify", title: "Action First", options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "notifyCategory", actions: [action], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    

}
