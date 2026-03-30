//
//  AppDI.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit

final class AppDI {
    static let shared = AppDI()

    let networkProvider: NetworkProvider
    let locationService: LocationServiceProtocol

    private(set) var navigationService: NavigationServiceProtocol?

    private init() {
        networkProvider = AlamofireNetworkProvider(baseURL: AppConfig.host)
        locationService = LocationService()
    }

    func configure(window: UIWindow) {
        navigationService = NavigationService(window: window)
    }
}
