//
//  URLs.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 15.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import Foundation
import UIKit

struct URLs {

    // MARK: - Main URLs Section
 

    private let baseURL = "http://api.openweathermap.org"
    private let apiKey = "249debd02da485df26d56c612c40cf33"
    fileprivate let currentAPIVersion : String! = "/data/2.5"
    
    // MARK: - URLs Section
    
    private var WEATHER_URL : String { get { return currentAPIVersion + "/weather?" } }
    
    // MARK: - Fields Section
    
    private let API_KEY_FIELD = "appid"
    private let LONGITUDE_FIELD = "lon"
    private let LATTITUDE_FIELD = "lat"
    private let UNITS_FIELD = "units"
    
    func getWeatherByCoordURL() -> String
    {
        return baseURL + WEATHER_URL
    }
    
    func getWeatherByCoordRequestUrl(latitude : Double,
                           longitude: Double) -> String
    {
        var body = ""
        body = addParamToBody(body, param: LATTITUDE_FIELD, value: String(latitude))
        body = addParamToBody(body, param: LONGITUDE_FIELD, value: String(longitude))
        body = addParamToBody(body, param: UNITS_FIELD, value: "metric")
        return getWeatherByCoordURL() + reqWithApiKey(body)
    }
    
    // MARK: - Internal section
    
    fileprivate func addParamToBody(_ body: String,
                                    param: String,
                                    value: String) -> String
    {
        var sign: String = "&"
        if body.isEmpty
        {
            sign = ""
        }
        return body + sign + param + "=" + value
    }
    
    fileprivate func reqWithApiKey(_ body: String) -> String
    {
        return body + "&" + API_KEY_FIELD + "=" + apiKey
    }
    
}
