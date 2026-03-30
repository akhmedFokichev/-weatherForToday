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
    case success(models: [SuccessViewModel])
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
            await fetchWeather(for: coordinate)
            
        } catch LocationServiceError.denied {
            // - пользвоатель запретил geo - используем коориднаты москвы
            await fetchWeather(for: AppConfig.moscowLocation)
            
        } catch {
            print(error)
        }
    }
    
    func fetchWeather(for coordinate: CLLocationCoordinate2D) async {
        let request = GetForecastRequest(
            apiKey: AppConfig.weatherapiKey,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            days: 3
        )
        do {
            let forecast = try await networkProvider.send(request)
            let loc = forecast.location
            let startOfCurrentHourEpoch = Self.startOfCurrentHourSince1970()
            let models: [SuccessViewModel] = forecast.forecast.forecastday.enumerated().map { idx, day in
                let d = day.day
                let hoursForDay: [GetForecastResponse.HourEntry]
                if idx == 0 {
                    hoursForDay = day.hour.filter { $0.timeEpoch >= startOfCurrentHourEpoch }
                } else {
                    hoursForDay = day.hour
                }
                let hourly = hoursForDay.map { h in
                    HourWeatherLine(
                        time: shortHourLabel(from: h.time),
                        detail: "\(formatTemp(h.tempC))"
                    )
                }
                return SuccessViewModel(
                    date: day.date,
                    title: loc.name,
                    region: "(\(loc.region), \(loc.country))",
                    tempC: "макс \(formatTemp(d.maxtempC))° · мин \(formatTemp(d.mintempC))° · ср \(formatTemp(d.avgtempC))°",
                    text: [
                        d.condition.text,
                        "ветер до \(Int(d.maxwindKph)) км/ч",
                        "осадки \(String(format: "%.1f", d.totalprecipMM)) мм",
                        "влажность \(Int(d.avghumidity))% · дождь \(d.dailyChanceOfRain)% · UV \(formatTemp(d.uv))",
                    ].joined(separator: " · "),
                    hourly: hourly
                )
            }
            state.accept(.success(models: models))
        } catch {
            print(error)
            state.accept(.error(error: "что-то пошло не так!"))
        }
    }

    func formatTemp(_ value: Double) -> String {
        String(format: "%.1f", value)
    }

    /// `"2026-03-30 15:00"` → `"15:00"`
    func shortHourLabel(from apiTime: String) -> String {
        if let space = apiTime.lastIndex(of: " ") {
            return String(apiTime[apiTime.index(after: space)...])
        }
        return apiTime
    }

    /// Начало текущего календарного часа (локальное время устройства), для сравнения с `time_epoch` в ответе API.
    static func startOfCurrentHourSince1970() -> Int {
        let now = Date()
        let cal = Calendar.current
        let start = cal.dateInterval(of: .hour, for: now)?.start ?? now
        return Int(start.timeIntervalSince1970)
    }
}
