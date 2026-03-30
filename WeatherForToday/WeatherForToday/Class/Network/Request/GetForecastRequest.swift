//
//  GetForecastRequest.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import Foundation
import Alamofire

struct GetForecastRequest: APIRequest {
    typealias Response = GetForecastResponse

    let apiKey: String
    let query: String
    /// Сколько дней прогноза (1…14), по умолчанию 3.
    let days: Int

    init(apiKey: String, latitude: Double, longitude: Double, days: Int = 3) {
        self.apiKey = apiKey
        self.query = "\(latitude),\(longitude)"
        self.days = days
    }

    init(apiKey: String, query: String, days: Int = 3) {
        self.apiKey = apiKey
        self.query = query
        self.days = days
    }

    var path: String { "/v1/forecast.json" }
    var method: HTTPMethod { .get }
    var parameters: Parameters? {
        ["key": apiKey, "q": query, "days": days]
    }

    var encoding: ParameterEncoding { URLEncoding.default }
}
