//
//  AppDelegate.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 13.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let serviceDispatcher = ServiceDispatcher(services: [MainAppService(),
                                              LocalNotificationService()])

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let appDir = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        print (appDir)
        serviceDispatcher.application(application, didFinishLaunchingWithOptions: launchOptions as [NSObject : AnyObject]?)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        serviceDispatcher.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        serviceDispatcher.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        serviceDispatcher.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        serviceDispatcher.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        serviceDispatcher.applicationWillTerminate(application)
        DBManager.sharedInstance.saveContext()
    }

}

