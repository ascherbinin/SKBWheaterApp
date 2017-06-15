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
    let serviceDispatcher = ServiceDispatcher(services: [MainAppService()])

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
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SKBWeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

