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
    var requestPermissionForLocationIfNeeded: CLAuthorizationStatus?
    var locationManager: CLLocationManager?
    
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            break
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
}
