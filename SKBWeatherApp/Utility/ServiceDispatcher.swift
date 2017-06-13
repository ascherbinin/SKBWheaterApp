//
//  ServiceDispatcher.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 13.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit

class ServiceDispatcher : NSObject, UIApplicationDelegate

{
    let services: [UIApplicationDelegate]
    
    init(services: [UIApplicationDelegate]) {
        self.services = services
    }

    @nonobjc func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        services.forEach { service in
            service.application!(application, didFinishLaunchingWithOptions: launchOptions as? [UIApplicationLaunchOptionsKey : Any])
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        services.forEach { service in
            service.applicationDidBecomeActive?(application)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        services.forEach { service in
            service.applicationWillResignActive?(application)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        services.forEach { service in
            service.applicationWillEnterForeground?(application)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        services.forEach { service in
            service.applicationDidEnterBackground?(application)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        services.forEach { service in
            service.applicationWillTerminate?(application)
        }
    }

}
