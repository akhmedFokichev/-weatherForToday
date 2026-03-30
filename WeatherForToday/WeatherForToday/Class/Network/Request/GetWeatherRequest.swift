//
//  GetWeatherRequest.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import Foundation
import Alamofire

struct GetWeatherRequest: APIRequest {
    typealias Response = GetWeatherResponse
    let apiKey: String
    let query: String
    /// Для `/v1/forecast.json`: число дней прогноза (1…14). Для `current.json` API обычно игнорирует.
    let days: Int?

    init(apiKey: String, latitude: Double, longitude: Double, days: Int? = nil) {
        self.apiKey = apiKey
        self.query = "\(latitude),\(longitude)"
        self.days = days
    }

    init(apiKey: String, query: String, days: Int? = nil) {
        self.apiKey = apiKey
        self.query = query
        self.days = days
    }

    var path: String { "/v1/current.json" }
    var method: HTTPMethod { .get }
    var parameters: Parameters? {
        var p: Parameters = ["key": apiKey, "q": query]
        if let days {
            p["days"] = days
        }
        return p
    }

    var encoding: ParameterEncoding { URLEncoding.default }
}
