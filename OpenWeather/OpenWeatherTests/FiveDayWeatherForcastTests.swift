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
    
    func testFiveDayWeatherForcastHasATableView() {
          let fiveDayController = UIStoryboard(name: "Main", bundle: Bundle(for: FiveDayForcastViewController.self)).instantiateViewController(withIdentifier: "FiveDayForcastViewController") as! FiveDayForcastViewController
        fiveDayController.loadViewIfNeeded()
        XCTAssertNotNil(fiveDayController.tableView)
    }
    
    func testFiveDayWeatherForcastDataSourceShouldBeNilOnViewDidLoad() {
        let fiveDayController = UIStoryboard(name: "Main", bundle: Bundle(for: FiveDayForcastViewController.self)).instantiateViewController(withIdentifier: "FiveDayForcastViewController") as! FiveDayForcastViewController
        fiveDayController.loadViewIfNeeded()
        XCTAssertTrue(fiveDayController.tableView.dataSource == nil)
    }
    
    func testViewControllerHasCorrectNumberOfRows() {
        let fiveDayController = UIStoryboard(name: "Main", bundle: Bundle(for: FiveDayForcastViewController.self)).instantiateViewController(withIdentifier: "FiveDayForcastViewController") as! FiveDayForcastViewController
        fiveDayController.loadViewIfNeeded()
       // fiveDayController.weatherResults
    }
    
    func testFiveDayWeatherForcastTableViewDelegateShouldBeNilOnViewDidLoad() {
        let fiveDayController = UIStoryboard(name: "Main", bundle: Bundle(for: FiveDayForcastViewController.self)).instantiateViewController(withIdentifier: "FiveDayForcastViewController") as! FiveDayForcastViewController
        fiveDayController.loadViewIfNeeded()
        XCTAssertTrue(fiveDayController.tableView.delegate == nil)
    }
    
    func testApplicationShouldCallGetWeatherForCurrentLocationWhenFiveDayForcastIsOpen() {
        subject?.viewDidLoad()
        assert(subject?.getWeatherWasCalled == true)
    }
    
    func testThatApplicationSetsUrlUsingCorrectCoordinatesAndApiKeyForFiveDayWeatherForcast() {
        subject?.getWeatherForCurrentLocation(latitude: "50", longitude: "50")
        let expectedURL = URL(string:"https://api.openweathermap.org/data/2.5/forecast?lat=50&lon=50&units=imperial&appid=d78bc971defb9c9c6d281dde9d133a02")
        XCTAssertEqual(subject?.weatherURL, expectedURL)
    }
}

class MockFiveDayWeatherForcast: FiveDayForcastViewController {
    var getWeatherWasCalled: Bool = false
    var weatherURL: URL?
    
    override func getWeatherForCurrentLocation(latitude: String, longitude: String) {
        getWeatherWasCalled = true
        weatherURL = URL(string:"https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(apiKey)")
    }
}
