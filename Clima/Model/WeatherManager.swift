//
//  WeatherManager.swift
//  Clima
//
//  Created by Scott Bedard on 10/22/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didGetWeatherData(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather?units=imperial"
    let APP_ID = "f16ddc18420ccbd4190c270d8f2bfc6e"

    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let fetchURL = "\(WEATHER_URL)&appid=\(APP_ID)&q=\(cityName)"
        performRequest(with: fetchURL)
    }

    func fetchWeather(latitude: Double, longitude: Double) {
        let fetchURL = "\(WEATHER_URL)&appid=\(APP_ID)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: fetchURL)
    }

    func performRequest(with urlString: String) {
        
        //1. Build URL
        let url = URL(string: urlString)
        
        if let safeURL = url {
            //2. Open Connectiong
            let session = URLSession(configuration: .default)
            
            //3. Set up task of getting data
            let task = session.dataTask(with: safeURL) { (data, response, error) in
                if error == nil {
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didGetWeatherData(self, weather: weather)
                        }
                    }
                } else {
                    self.delegate?.didFailWithError(error: error!)
                }
            }
        
            //4. start the suspended task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(cityName: cityName, conditionId: id, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
