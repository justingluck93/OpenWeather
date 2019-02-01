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
    
    func testThatApplicationCallsShowWeatherPermissionDeniedAlertWhenAuthorizationStatusIsDenied() {
        let manager = MockLocationManager()
        subject?.locationManager = manager
        subject?.locationManager(manager, didChangeAuthorization: .denied)
        XCTAssertEqual(subject?.locationManager?.desiredAccuracy, kCLLocationAccuracyBest)
        assert(subject?.locationPermissionAlertCalled == true)
    }
    
    func testThatApplicationUpdatesCoordinates() {
        let manager = MockLocationManager()
        subject?.locationManager = manager
        subject?.locationManager(manager, didUpdateLocations: [CLLocation(latitude: 50, longitude: 80)])
        XCTAssertEqual(subject?.latitude, "50.0")
        XCTAssertEqual(subject?.longitude, "80.0")
        
    }
    
    func testThatUpdateWeatherIsCalledAfterCoordinatesAreUpdated() {
        let manager = MockLocationManager()
        subject?.locationManager = manager
        subject?.locationManager(manager, didUpdateLocations: [CLLocation(latitude: 50, longitude: 80)])
        assert(subject?.getWeatherWasCalled == true)
    }
    
    func testThatApplicationSetsUrlUsingCorrectCoordinatesAndApiKey() {
        let subject = WeatherViewController()
        subject.getWeatherForCurrentLocation(latitude: "50", longitude: "50")
        let expectedURL = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=50&lon=50&units=imperial&appid=d78bc971defb9c9c6d281dde9d133a02")
        XCTAssertEqual(subject.dayForcastURL, expectedURL)
        
    }
}

class MockWeatherVC: WeatherViewController {
    var didRequestLocationPermissionCalled: Bool = false
    var locationPermissionAlertCalled: Bool = false
    var getWeatherWasCalled: Bool = false
    var weatherURL: URL?
    
    override func requestLocationPermission() {
        didRequestLocationPermissionCalled = true
    }
    
    override func showLocationPermissionAlert() {
        locationPermissionAlertCalled = true
    }
    
    override func getWeatherForCurrentLocation(latitude: String, longitude: String) {
        getWeatherWasCalled = true
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
