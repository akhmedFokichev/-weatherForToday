//
//  GetForecastResponse.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import Foundation

/// Ответ `GET /v1/forecast.json` (WeatherAPI).
struct GetForecastResponse: Decodable {
    let location: Location
    let forecast: Forecast

    struct Location: Decodable {
        let name: String
        let region: String
        let country: String

        private enum CodingKeys: String, CodingKey {
            case name
            case region
            case country
        }
    }

    struct Forecast: Decodable {
        let forecastday: [ForecastDay]
    }

    struct ForecastDay: Decodable {
        let date: String
        let day: DayWeather
        let hour: [HourEntry]
    }

    struct HourEntry: Decodable {
        let timeEpoch: Int
        let time: String
        let tempC: Double
        let condition: Condition

        private enum CodingKeys: String, CodingKey {
            case timeEpoch = "time_epoch"
            case time
            case tempC = "temp_c"
            case condition
        }
    }

    struct DayWeather: Decodable {
        let maxtempC: Double
        let mintempC: Double
        let avgtempC: Double
        let maxwindKph: Double
        let totalprecipMM: Double
        let avghumidity: Double
        let dailyChanceOfRain: Int
        let condition: Condition
        let uv: Double

        private enum CodingKeys: String, CodingKey {
            case maxtempC = "maxtemp_c"
            case mintempC = "mintemp_c"
            case avgtempC = "avgtemp_c"
            case maxwindKph = "maxwind_kph"
            case totalprecipMM = "totalprecip_mm"
            case avghumidity
            case dailyChanceOfRain = "daily_chance_of_rain"
            case condition
            case uv
        }
    }

    struct Condition: Decodable {
        let text: String
        let code: Int
    }
}
