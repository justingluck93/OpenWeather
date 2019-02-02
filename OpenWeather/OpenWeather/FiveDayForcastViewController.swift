//
//  FiveDayForcastViewController.swift
//  OpenWeather
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import UIKit
import CoreLocation

class FiveDayForcastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var weatherResults: FiveDayWeatherForcast?
    let apiKey: String = "d78bc971defb9c9c6d281dde9d133a02"

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        getWeatherForCurrentLocation(latitude: "42.6584", longitude: "-83.1499")
    }

    func getWeatherForCurrentLocation(latitude: String, longitude: String) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(apiKey)")
        
        let session = URLSession.shared
        
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
                    self.tableView.reloadData()
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
        
        let cellSubTitle = weatherResults.list[indexPath.row].dt
        weatherCell.detailTextLabel?.text = "\(cellSubTitle)"
        
        let cellImage = 
        
        return weatherCell
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


