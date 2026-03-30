//
//  MainScreenViewModel.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import CoreLocation
import RxRelay
import RxSwift

enum MainScreenState {
    case initialization
    case loading
    case error(error: String)
    case success(model: SuccessViewModel)
}

final class MainScreenViewModel {
    
    let state = BehaviorRelay<MainScreenState>(value: .initialization)
    
    private let disposeBag = DisposeBag()
    private let locationService: LocationServiceProtocol
    private let networkProvider: NetworkProvider
    
    init(_ di: AppDI = .shared) {
        self.locationService = di.locationService
        self.networkProvider = di.networkProvider
    }
    
    func viewDidLoad() {
        state.accept(.loading)
        Task { await startLocationService() }
    }
    
    func tapRetry() {
        viewDidLoad()
    }
}

private extension MainScreenViewModel {
    
    func startLocationService() async {
        do {
            let coordinate = try await locationService.requestCurrentLocation()
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            await fetchWeather(for: coordinate)
            
        } catch LocationServiceError.denied {
            // - пользвоатель запретил geo - используем коориднаты москвы
            await fetchWeather(for: AppConfig.moscowLocation)
            
        } catch {
            print(error)
        }
    }
    
    func fetchWeather(for coordinate: CLLocationCoordinate2D) async {
        let request = GetWeatherRequest(
            apiKey: AppConfig.weatherapiKey,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        do {
            let weather = try await networkProvider.send(request)
            print(weather.current.tempC, weather.location.name)
            
            let model: SuccessViewModel = .init(
                title: weather.location.name,
                region:  "(" + weather.location.region + ")",
                tempC: "температура воздуха: " + String(weather.current.tempC) + "°C",
                text: weather.current.condition.text
            )
            state.accept(.success(model: model))
            
        } catch {
            print(error)
            state.accept(.error(error: "что-то пошло не так!"))
        }
    }
    

}
