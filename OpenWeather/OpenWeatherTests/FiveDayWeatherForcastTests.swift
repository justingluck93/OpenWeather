//
//  FiveDayWeatherForcastTests.swift
//  OpenWeatherTests
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import XCTest
import CoreLocation
@testable import OpenWeather

class FiveDayWeatherForcastTests: XCTestCase {
    
    var subject: MockFiveDayWeatherForcast?
    var fakeJSONDecodable: FiveDayWeatherForcast = FiveDayWeatherForcast(list: [OpenWeather.ThreeHourInterval(dt: 1549130400.0, main: OpenWeather.Main(temp: 42.170000000000002), weather: [OpenWeather.Weather(icon: "02d")]), OpenWeather.ThreeHourInterval(dt: 1549141200.0, main: OpenWeather.Main(temp: 46.039999999999999), weather: [OpenWeather.Weather(icon: "10d")]), OpenWeather.ThreeHourInterval(dt: 1549152000.0, main: OpenWeather.Main(temp: 42.75), weather: [OpenWeather.Weather(icon: "10n")])], city: OpenWeather.City(name: "Auburn Hills"))
    
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
    
    func testFiveDayWeatherForcastTableViewDelegateShouldBeNilOnViewDidLoad() {
        let fiveDayController = UIStoryboard(name: "Main", bundle: Bundle(for: FiveDayForcastViewController.self)).instantiateViewController(withIdentifier: "FiveDayForcastViewController") as! FiveDayForcastViewController
        fiveDayController.loadViewIfNeeded()
        XCTAssertTrue(fiveDayController.tableView.delegate == nil)
    }
    
    func testTableViewShouldHaveCorrectNumberOfRows(){
        let fiveDayController = UIStoryboard(name: "Main", bundle: Bundle(for: FiveDayForcastViewController.self)).instantiateViewController(withIdentifier: "FiveDayForcastViewController") as! FiveDayForcastViewController
        fiveDayController.loadViewIfNeeded()
        fiveDayController.weatherResults = fakeJSONDecodable
        let expectedRows = fiveDayController.tableView(fiveDayController.tableView, numberOfRowsInSection: 1)
        XCTAssertEqual(expectedRows, 3)
    }
    
    func testTableViewCellsHasCorrectInformationBasedOnData() {
        let fiveDayController = UIStoryboard(name: "Main", bundle: Bundle(for: FiveDayForcastViewController.self)).instantiateViewController(withIdentifier: "FiveDayForcastViewController") as! FiveDayForcastViewController
        fiveDayController.loadViewIfNeeded()
        fiveDayController.weatherResults = fakeJSONDecodable
        let myCell = fiveDayController.tableView(fiveDayController.tableView, cellForRowAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(myCell.textLabel?.text, "42 ℉")
        XCTAssertEqual(myCell.detailTextLabel?.text, "Sat, Feb 2 1:00 PM")
    }
    
    func testThatUpdateWeatherIsCalledAfterCoordinatesAreUpdated() {
        let manager = MockLocationManager()
        subject?.locationManager = manager
        subject?.locationManager(manager, didUpdateLocations: [CLLocation(latitude: 50, longitude: 80)])
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
