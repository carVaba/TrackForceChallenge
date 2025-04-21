import Foundation
import CoreLocation

struct ForecastInfo: Codable {
    let city: CityInfo
    let current: DayForecast
    let daily: [DayForecast]
}

struct CityInfo: Codable {
    let name: String
    let coordinate: LocationCoordinate
}

struct DayForecast: Codable {
    let date: Date
    let temperature: TemperatureRange
    let weatherDescription: String
    let icon: String
}
    
struct TemperatureRange: Codable {
    let current: Double
    let min: Double
    let max: Double
}
