//
//  WeatherData.swift
//  Clima
//
//  Created by Scott Bedard on 10/22/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var description: String
    var id: Int
}
