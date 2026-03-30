//
//  AppConfig.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import CoreLocation

enum AppConfig {
    static let host = "https://api.weatherapi.com"
    
    static let weatherapiKey = "fa8b3df74d4042b9aa7135114252304"
    
    static let moscowLocation: CLLocationCoordinate2D = .init(latitude: 55.7522, longitude: 37.6156)
}
