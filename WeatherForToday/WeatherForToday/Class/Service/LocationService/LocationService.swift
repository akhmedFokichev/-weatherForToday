//
//  LocationService.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import CoreLocation

enum LocationServiceError: Error {
    case servicesDisabled
    case denied
    case restricted
    case unableToDetermine
}

protocol LocationServiceProtocol: AnyObject {
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D
}

final class LocationService: NSObject, LocationServiceProtocol {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationServiceError.servicesDisabled
        }

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return try await requestLocationOnce()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            return try await requestLocationOnce()
        case .denied:
            throw LocationServiceError.denied
        case .restricted:
            throw LocationServiceError.restricted
        @unknown default:
            throw LocationServiceError.unableToDetermine
        }
    }

    private func requestLocationOnce() async throws -> CLLocationCoordinate2D {
        if let cached = manager.location?.coordinate {
            return cached
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let continuation else { return }

        switch manager.authorizationStatus {
        case .denied:
            self.continuation = nil
            continuation.resume(throwing: LocationServiceError.denied)
        case .restricted:
            self.continuation = nil
            continuation.resume(throwing: LocationServiceError.restricted)
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let continuation else { return }
        self.continuation = nil

        if let coordinate = locations.last?.coordinate {
            continuation.resume(returning: coordinate)
        } else {
            continuation.resume(throwing: LocationServiceError.unableToDetermine)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let continuation else { return }
        self.continuation = nil
        continuation.resume(throwing: error)
    }
}
