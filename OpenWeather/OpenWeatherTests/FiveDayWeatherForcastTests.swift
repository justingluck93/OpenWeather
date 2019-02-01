//
//  FiveDayWeatherForcastTests.swift
//  OpenWeatherTests
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import XCTest

@testable import OpenWeather

class FiveDayWeatherForcastTests: XCTestCase {
    
    var subject: MockFiveDayWeatherForcast?
    
    override func setUp() {
        super.setUp()
        subject = MockFiveDayWeatherForcast()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testApplicationShouldCallGetWeatherForCurrentLocationWhenFiveDayForcastIsOpen() {
        subject?.viewDidLoad()
        assert(subject?.getWeatherWasCalled == true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class MockFiveDayWeatherForcast: FiveDayForcastViewController {
    var getWeatherWasCalled: Bool = false
    
    override func getWeatherForCurrentLocationx(latitude: String, longitude: String) {
        getWeatherWasCalled = true
    }
    
}
