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
    var weatherResults: WeatherResults?
    
    //IBOutlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
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
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "Location Permission Denied", message: "Please turn on location settings in settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func getWeatherForCurrentLocation(latitude: String, longitude: String) {
        guard let weatherUrl = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\("imperial")&appid=\(apiKey)") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: weatherUrl) { (data, response, error) in
            if let data = data {
                do {
                    self.weatherResults = try JSONDecoder().decode(WeatherResults.self, from: data)
                } catch {
                    return
                }
                DispatchQueue.main.sync {
                    self.updateWeather()
                }
            }
        }.resume()
    }
    
    func updateWeather() {
        guard var weatherResults = weatherResults else {
            return
        }
        
        self.cityLabel.text = "\(weatherResults.name)"
        self.tempLabel.text = "\(Int(weatherResults.main.temp.rounded())) ℉ "
        self.weatherIcon.image = UIImage(data: getImageFromUrl(iconIdentifier: weatherResults.weather[0].icon))
        self.timeLabel.text = convertDate(milliseconds: weatherResults.dt)
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

struct WeatherResults: Decodable {
    var main: Main
    var name: String
    var weather: [Weather]
    var dt: Double
}

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var icon: String
}
