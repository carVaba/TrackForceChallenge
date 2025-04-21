import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Decodable {
    let cod: String
    let message, cnt: Int
    let list: [ItemWeatherResponse]
    let city: CityWeatherResponse
}

// MARK: - CityWeatherResponse
struct CityWeatherResponse: Decodable {
    let id: Int
    let name: String
    let coord: CoordWeatherResponse
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - CoordWeatherResponse
struct CoordWeatherResponse: Decodable {
    let lat, lon: Double
}

// MARK: - ItemWeatherResponse
struct ItemWeatherResponse: Decodable {
    let dt: Int
    let main: MainWeatherResponse
    let weather: [WeatherInfoResponse] // Next hours
    let clouds: CloudWeatherResponse
    let wind: WindWeatherResponse
    let visibility, pop: Int
    let sys: SysWeatherResponse
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - CloudWeatherResponse
struct CloudWeatherResponse: Decodable {
    let all: Int
}

// MARK: - MainWeatherResponse
struct MainWeatherResponse: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - SysWeatherResponse
struct SysWeatherResponse: Decodable {
    let pod: String
}

// MARK: - WeatherInfoResponse
struct WeatherInfoResponse: Decodable {
    let id: Int
    let main, description, icon: String
}

// MARK: - WindWeatherResponse
struct WindWeatherResponse: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}
