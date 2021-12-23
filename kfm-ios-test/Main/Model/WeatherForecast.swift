//
//  WeatherForecast.swift
//  kfm-ios-test
//
//  Created by Yudha on 23/12/21.
//

import Foundation

struct WeatherForecast: Decodable {
    var forecastDay: [WeatherForecastDay]
    
    enum CodingKeys: String, CodingKey {
        case forecastDay = "forecastday"
    }
}

struct WeatherForecastDay: Decodable {
    var date: String
    var dateEpoch: Int
    var day: WeatherDaily
    var astro: WeatherAstro
    var hour: [WeatherDayHour]
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day
        case astro
        case hour
    }
}

struct WeatherDaily: Decodable {
    var maxTempC: Double
    var maxTempF: Double
    var minTempC: Double
    var minTempF: Double
    var averageTempC: Double
    var averageTempF: Double
    var willItRain: Int
    var chanceOfRain: Int
    var willItSnow: Int
    var chanceOfSnow: Int
    var condition: WeatherCondition
    var uv: Double
    
    enum CodingKeys: String, CodingKey {
        case maxTempC = "maxtemp_c"
        case maxTempF = "maxtemp_f"
        case minTempC = "mintemp_c"
        case minTempF = "mintemp_f"
        case averageTempC = "avgtemp_c"
        case averageTempF = "avgtemp_f"
        case willItRain = "daily_will_it_rain"
        case chanceOfRain = "daily_chance_of_rain"
        case willItSnow = "daily_will_it_snow"
        case chanceOfSnow = "daily_chance_of_snow"
        case condition
        case uv
    }
}

struct WeatherAstro: Decodable {
    var sunrise: String
    var sunset: String
    var moonrise: String
    var moonset: String
    var moon_phase: String
    var moon_illumination: String
}

struct WeatherDayHour: Decodable {
    var timeEpoch: Int
    var time: String
    var tempC: Double
    var tempF: Double
    var isDay: Int
    var condition: WeatherCondition
    var feelsLikeC: Double
    var feelsLikeF: Double
    var willItRain: Int
    var chanceOfRain: Int
    var willItSnow: Int
    var chanceOfSnow: Int
    var uv: Double
    
    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case feelsLikeC = "feelslike_c"
        case feelsLikeF = "feelslike_f"
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
        case uv
    }
}
