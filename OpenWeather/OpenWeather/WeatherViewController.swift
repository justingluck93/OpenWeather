//
//  ViewController.swift
//  OpenWeather
//
//  Created by admin on 2/1/19.
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

