//
//  Weather.swift
//  kfm-ios-test
//
//  Created by Yudha on 23/12/21.
//

import Foundation

struct Weather: Decodable {
    var location: WeatherLocation
    var current: WeatherCurrent
    var forecast: WeatherForecast
}

struct WeatherLocation: Decodable {
    var name: String
    var region: String
    var country: String
    var lat: Double
    var lon: Double
    var timezone: String
    var localTimeEpoch: Int
    var localTime: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
        case lat
        case lon
        case timezone = "tz_id"
        case localTimeEpoch = "localtime_epoch"
        case localTime = "localtime"
    }
}

struct WeatherCurrent: Decodable {
    var lastUpdatedEpoch: Int
    var lastUpdated: String
    var tempCelcius: Double
    var tempFahrenheit: Double
    var windKph: Double
    var humidity: Int
    var isDay: Int
    var condition: WeatherCondition
    
    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempCelcius = "temp_c"
        case tempFahrenheit = "temp_f"
        case windKph = "wind_kph"
        case humidity
        case isDay = "is_day"
        case condition
    }
}

struct WeatherCondition: Decodable {
    var text: String
    var icon: String
    var code: Int
}
