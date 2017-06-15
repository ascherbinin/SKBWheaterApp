//
//  Weather+CoreDataClass.swift
//  
//
//  Created by Андрей Щербинин on 15.06.17.
//
//

import Foundation
import CoreData

@objc(Weather)
public class Weather: NSManagedObject {

    convenience init()
    {
        // Создание нового объекта
        self.init(entity: DBManager.instance.entityForName(entityName: "Weather"), insertInto: DBManager.instance.managedObjectContext)
    }
}
