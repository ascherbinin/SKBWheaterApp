//
//  WeatherStateTest.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 20.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import XCTest
@testable import SKBWeatherApp

class WeatherStateTest: XCTestCase {
    
    var stateController: WeatherStateController!
    override func setUp() {
        super.setUp()
        stateController = WeatherStateController()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitStateController()
    {
        XCTAssertTrue(stateController != nil, "State контроллер нормально инициализирован")
    }
    
    
    func testGetCurrentWeather()
    {
        let weather = stateController.currentWeather
        XCTAssertNil(weather, "Пустое значение текущей погоды")
    }
}
