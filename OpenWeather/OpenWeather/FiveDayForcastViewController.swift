//
//  FiveDayForcastViewController.swift
//  OpenWeather
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import UIKit
import CoreLocation

class FiveDayForcastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var weatherResults: FiveDayWeatherForcast?
    let apiKey: String = "d78bc971defb9c9c6d281dde9d133a02"
    var locationManager: CLLocationManager?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = locationManager == nil ? CLLocationManager() : locationManager
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    func getWeatherForCurrentLocation(latitude: String, longitude: String) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(apiKey)")
        
        let session = URLSession.shared
        
        spinner.startAnimating()
        session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    self.weatherResults = try JSONDecoder().decode(FiveDayWeatherForcast.self, from: data)
                } catch {
                    return
                }
                DispatchQueue.main.sync {
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    UIView.transition(with: self.tableView,
                                      duration: 0.35,
                                      options: .transitionCrossDissolve,
                                      animations: { self.tableView.reloadData() })
                    self.spinner.stopAnimating()
                }
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = weatherResults?.list.count else { fatalError() }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var weatherResults = weatherResults else { fatalError() }
        let weatherCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        let cellTitle = Int(weatherResults.list[indexPath.row].main.temp.rounded())
        weatherCell.textLabel?.text = "\(cellTitle) ℉"
        
        let cellSubTitle = convertDate(milliseconds: weatherResults.list[indexPath.row].dt)
        weatherCell.detailTextLabel?.text = "\(cellSubTitle)"
        
        let cellImage = getImageFromUrl(iconIdentifier: weatherResults.list[indexPath.row].weather[0].icon)
        weatherCell.imageView?.image = UIImage(data: cellImage)
        
        return weatherCell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        
        guard let location = locations.first else { return }
        
        let latitude = "\(location.coordinate.latitude)"
        let longitude = "\(location.coordinate.longitude)"
        
        getWeatherForCurrentLocation(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            showLocationPermissionAlert()
        case .notDetermined:
            break
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
        case .authorizedAlways:
            break
        case .restricted:
            break
        }
    }
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "Location Permission Denied", message: "Please turn on location in settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

}

struct FiveDayWeatherForcast: Decodable {
    var list: [ThreeHourInterval]
    var city: City
}

struct ThreeHourInterval: Decodable {
    var dt: Double
    var main: Main
    var weather: [Weather]
}

struct City: Decodable {
    var name: String
}
