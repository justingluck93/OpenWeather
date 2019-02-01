//
//  ViewController.swift
//  OpenWeather
//
//  Created by Justin Gluck on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    let apiKey: String = "d78bc971defb9c9c6d281dde9d133a02"
    var requestPermissionForLocationIfNeeded: CLAuthorizationStatus?
    var locationManager: CLLocationManager?
    var latitude: String?
    var longitude: String?
    var dayForcastURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(requestPermissionForLocationIfNeeded == nil) {
            requestPermissionForLocationIfNeeded = CLLocationManager.authorizationStatus()
        }
        
        locationManager = locationManager == nil ? CLLocationManager() : locationManager
        locationManager?.delegate = self
        
        if(requestPermissionForLocationIfNeeded == .notDetermined) {
            requestLocationPermission()
        }
    }

    func requestLocationPermission() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "Location Permission Denied", message: "Please turn on location settings in settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func getWeatherForCurrentLocation(latitude: String, longitude: String) {
        dayForcastURL = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\("imperial")&appid=\(apiKey)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            showLocationPermissionAlert()
        case .notDetermined:
            requestLocationPermission()
            break
        case .authorizedWhenInUse:
            startUpdatingLocation()
            break
        case .authorizedAlways:
            break
        case .restricted:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        
        guard let location = locations.first else { return }
        
        latitude = "\(location.coordinate.latitude)"
        longitude = "\(location.coordinate.longitude)"
        
        getWeatherForCurrentLocation(latitude: latitude!, longitude: longitude!)
        
    }
}
