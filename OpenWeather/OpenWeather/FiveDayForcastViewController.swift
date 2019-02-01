//
//  FiveDayForcastViewController.swift
//  OpenWeather
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import UIKit
import CoreLocation

class FiveDayForcastViewController: UIViewController {
    let apiKeyx: String = "d78bc971defb9c9c6d281dde9d133a02"

    override func viewDidLoad() {
       getWeatherForCurrentLocationx(latitude: "42.6584", longitude: "-83.1499")
    }

    func getWeatherForCurrentLocationx(latitude: String, longitude: String) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(apiKeyx)")
        
        let session = URLSession.shared
        
        session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    let weatherResults = try JSONDecoder().decode(FiveDayWeatherForcast.self, from: data)
                    print(weatherResults.city.name)
                    print(weatherResults.list[0].main.temp)
                    
                } catch {
                    return
                }
                DispatchQueue.main.sync {
                    
                }
            }
        }.resume()
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


