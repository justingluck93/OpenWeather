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
    
    var subject: MockWeatherVC?
    
    override func setUp() {
        super.setUp()
        subject = MockWeatherVC()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatApplicationRequestsLocationPermissionIfNeeded() {
        subject?.requestPermissionForLocationIfNeeded = .notDetermined
        subject?.viewDidLoad()
        assert(subject?.didRequestLocationPermissionCalled == true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class MockWeatherVC: WeatherViewController {
    var didRequestLocationPermissionCalled: Bool = false
    
    override func requestLocationPermission() {
        didRequestLocationPermissionCalled = true
    }
}
