//
//  OpenWeatherTests.swift
//  OpenWeatherTests
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import XCTest
@testable import OpenWeather

class OpenWeatherTests: XCTestCase {
    
    var subject: WeatherViewController?
    
    override func setUp() {
        super.setUp()
        subject = WeatherViewController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatApplicationRequestsLocationPermissionIfNeeded() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
