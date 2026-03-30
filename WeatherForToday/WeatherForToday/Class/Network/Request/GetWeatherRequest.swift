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

    init(apiKey: String, latitude: Double, longitude: Double) {
        self.apiKey = apiKey
        self.query = "\(latitude),\(longitude)"
    }

    init(apiKey: String, query: String) {
        self.apiKey = apiKey
        self.query = query
    }

    var path: String { "/v1/current.json" }
    var method: HTTPMethod { .get }
    var parameters: Parameters? { ["key": apiKey, "q": query] }
    var encoding: ParameterEncoding { URLEncoding.default }
}
