//
//  GetWeatherResponse.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

struct GetWeatherResponse: Decodable {
    let location: Location
    let current: Current

    struct Location: Decodable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let tzID: String
        let localtimeEpoch: Int
        let localtime: String

        private enum CodingKeys: String, CodingKey {
            case name
            case region
            case country
            case lat
            case lon
            case tzID = "tz_id"
            case localtimeEpoch = "localtime_epoch"
            case localtime
        }
    }

    struct Current: Decodable {
        let lastUpdatedEpoch: Int
        let lastUpdated: String
        let tempC: Double
        let tempF: Double
        let isDay: Int
        let condition: Condition
        let windMPH: Double
        let windKPH: Double
        let windDegree: Int
        let windDir: String
        let pressureMB: Double
        let pressureIN: Double
        let precipMM: Double
        let precipIN: Double
        let humidity: Int
        let cloud: Int
        let feelslikeC: Double
        let feelslikeF: Double
        let windchillC: Double
        let windchillF: Double
        let heatindexC: Double
        let heatindexF: Double
        let dewpointC: Double
        let dewpointF: Double
        let visKM: Double
        let visMiles: Double
        let uv: Double
        let gustMPH: Double
        let gustKPH: Double

        private enum CodingKeys: String, CodingKey {
            case lastUpdatedEpoch = "last_updated_epoch"
            case lastUpdated = "last_updated"
            case tempC = "temp_c"
            case tempF = "temp_f"
            case isDay = "is_day"
            case condition
            case windMPH = "wind_mph"
            case windKPH = "wind_kph"
            case windDegree = "wind_degree"
            case windDir = "wind_dir"
            case pressureMB = "pressure_mb"
            case pressureIN = "pressure_in"
            case precipMM = "precip_mm"
            case precipIN = "precip_in"
            case humidity
            case cloud
            case feelslikeC = "feelslike_c"
            case feelslikeF = "feelslike_f"
            case windchillC = "windchill_c"
            case windchillF = "windchill_f"
            case heatindexC = "heatindex_c"
            case heatindexF = "heatindex_f"
            case dewpointC = "dewpoint_c"
            case dewpointF = "dewpoint_f"
            case visKM = "vis_km"
            case visMiles = "vis_miles"
            case uv
            case gustMPH = "gust_mph"
            case gustKPH = "gust_kph"
        }
    }

    struct Condition: Decodable {
        let text: String
        let icon: String
        let code: Int
    }
}
