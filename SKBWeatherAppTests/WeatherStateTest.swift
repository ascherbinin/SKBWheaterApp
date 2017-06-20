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
        var weater = stateController.currentWeather
        XCTAssertNil(weater, "Пустое значение текущей погоды")
        stateController.startGetLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            weater = self.stateController.currentWeather
            XCTAssertNotNil(weater, "Получено значение текущей погоды")
        })
        
    }
}
