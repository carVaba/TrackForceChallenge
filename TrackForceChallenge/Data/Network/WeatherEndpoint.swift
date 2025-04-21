import Foundation

struct WeatherEndpoint {
    static let baseURL = "https://api.openweathermap.org/data/2.5/forecast/"

    static func forecastURL(for coordinate: LocationCoordinate,
                            days: Int,
                            apiKey: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
            URLQueryItem(name: "cnt", value: "\(days)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric") // optional
        ]
        return components?.url
    }
}
