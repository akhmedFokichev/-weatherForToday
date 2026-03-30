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
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationServiceError.servicesDisabled
        }

        let status = await authorizationStatusDetermined()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return try await requestLocationOnce()
        case .denied:
            throw LocationServiceError.denied
        case .restricted:
            throw LocationServiceError.restricted
        case .notDetermined:
            throw LocationServiceError.unableToDetermine
        @unknown default:
            throw LocationServiceError.unableToDetermine
        }
    }

    /// Ждём, пока пользователь ответит на диалог (или пока статус уже известен).
    private func authorizationStatusDetermined() async -> CLAuthorizationStatus {
        if manager.authorizationStatus != .notDetermined {
            return manager.authorizationStatus
        }
        return await withCheckedContinuation { continuation in
            authorizationContinuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }

    private func requestLocationOnce() async throws -> CLLocationCoordinate2D {
        if let cached = manager.location?.coordinate, manager.authorizationStatus != .notDetermined {
            return cached
        }

        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            manager.requestLocation()
        }
    }

    private func finishLocationContinuation(
        throwing error: Error? = nil,
        coordinate: CLLocationCoordinate2D? = nil
    ) {
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil
        if let error {
            continuation.resume(throwing: error)
        } else if let coordinate {
            continuation.resume(returning: coordinate)
        } else {
            continuation.resume(throwing: LocationServiceError.unableToDetermine)
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        if let cont = authorizationContinuation, status != .notDetermined {
            authorizationContinuation = nil
            cont.resume(returning: status)
        }

        switch status {
        case .denied:
            finishLocationContinuation(throwing: LocationServiceError.denied)
        case .restricted:
            finishLocationContinuation(throwing: LocationServiceError.restricted)
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            finishLocationContinuation(coordinate: coordinate)
        } else {
            finishLocationContinuation(throwing: LocationServiceError.unableToDetermine)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            finishLocationContinuation(throwing: LocationServiceError.denied)
            return
        }
        finishLocationContinuation(throwing: error)
    }
}
