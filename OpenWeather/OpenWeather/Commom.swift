//
//  Commom.swift
//  OpenWeather
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 justingluck. All rights reserved.
//

import Foundation
import UIKit

func convertDate(milliseconds: Double) -> String {
    let date = Date(timeIntervalSince1970: milliseconds)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "E, MMM d h:mm a"
    
    return dateFormatter.string(from: date)
}

func getImageFromUrl(iconIdentifier: String) -> Data  {
    guard let iconURL = URL(string: "https://openweathermap.org/img/w/\(iconIdentifier).png"),
    let data = try? Data(contentsOf:iconURL) else { fatalError() }
    return data
}
