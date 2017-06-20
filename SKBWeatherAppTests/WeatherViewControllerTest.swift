//
//  WeatherViewControllerTest.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 20.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import XCTest
import UIKit
import CoreData
@testable import SKBWeatherApp


class WeatherViewControllerTest: XCTestCase {
    
    var weatherVC: WeatherViewController!
    var stateController: WeatherStateController!
    
    override func setUp() {
        super.setUp()
        weatherVC = WeatherViewController()
        stateController = WeatherStateController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStateControllerPropertySetAfterLoading() {
        // when
        // 1
        XCTAssertNil(weatherVC.stateController, "Перед загрузкой, state контроллер не инициализирован")
        
        // 2
        weatherVC.stateController = stateController
        
        // then
        // 3
        XCTAssertTrue(weatherVC.stateController != nil, "Контроллер погоды инициализирован вместе с state контроллером")
        XCTAssert(weatherVC.stateController === stateController,
                  "State контроллер в контроллере погоды равен созданному state контроллеру")
    }
    
}
