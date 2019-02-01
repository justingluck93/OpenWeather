//
//  OpenWeatherTests.swift
//  OpenWeatherTests
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import XCTest
import CoreLocation

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
    
    func testThatApplicationStartsUpdatingUserLocationWhenPermissionIsAuthorized() {
        let manager = MockLocationManager()
        subject?.locationManager = manager
        subject?.locationManager(manager, didChangeAuthorization: .authorizedWhenInUse)
        assert(manager.didStartUpdatintLocationCalled)
    }
    
    
}

class MockWeatherVC: WeatherViewController {
    var didRequestLocationPermissionCalled: Bool = false
    
    override func requestLocationPermission() {
        didRequestLocationPermissionCalled = true
    }
}

class MockLocationManager: CLLocationManager {
    var didStartUpdatintLocationCalled = false
    
    override init() {
        super.init()
    }
    
    override func startUpdatingLocation() {
        didStartUpdatintLocationCalled = true
    }
}
