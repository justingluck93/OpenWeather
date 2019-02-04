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
    var fakeJSONDecodable = WeatherResults(main: OpenWeather.Main(temp: 47.170000000000002), name: "Auburn Hills", weather: [OpenWeather.Weather(icon: "50d")], dt: 1549216380.0)

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
        assert(manager.didStartUpdatingLocationCalled)
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
        subject?.getWeatherForCurrentLocation(latitude: "50", longitude: "50")
        let expectedURL = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=50&lon=50&units=imperial&appid=d78bc971defb9c9c6d281dde9d133a02")
        XCTAssertEqual(subject?.weatherURL, expectedURL)
    }
    
    func testThatApplicationUpdatesUIElementsWithCorrectDataFromServie() {
        let weatherForcast = UIStoryboard(name: "Main", bundle: Bundle(for: WeatherViewController.self)).instantiateViewController(withIdentifier: "WeatherForcast") as! WeatherViewController
        weatherForcast.loadViewIfNeeded()
        weatherForcast.weatherResults = fakeJSONDecodable
        weatherForcast.updateWeather()
        
        guard let expectedCity = weatherForcast.cityLabel.text,
              let expectedTime = weatherForcast.timeLabel.text,
              let expectedTemperature = weatherForcast.tempLabel.text
            else { fatalError("Object is Nil") }
        
        XCTAssertEqual(expectedCity, "Auburn Hills")
        XCTAssertEqual(expectedTemperature, "47 ℉ ")
        XCTAssertEqual(expectedTime, "Sun, Feb 3 12:53 PM")
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
        weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\("imperial")&appid=\(apiKey)")
    }
}

class MockLocationManager: CLLocationManager {
    var didStartUpdatingLocationCalled = false
    
    override init() {
        super.init()
    }
    
    override func startUpdatingLocation() {
        didStartUpdatingLocationCalled = true
    }
}
