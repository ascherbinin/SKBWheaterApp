//
//  Weather+CoreDataProperties.swift
//  
//
//  Created by Андрей Щербинин on 15.06.17.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var temperature: Float
    @NSManaged public var cityName: String?
    @NSManaged public var countryName: String?
    @NSManaged public var iconName: String?
    @NSManaged public var lat: Float
    @NSManaged public var lon: Float
    @NSManaged public var weatherTitle: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var dt: NSDate?
    @NSManaged public var windSpeed: Float
    @NSManaged public var windDeg: Int16
    @NSManaged public var clouds: Int16
    @NSManaged public var weatherId: Int16

}
