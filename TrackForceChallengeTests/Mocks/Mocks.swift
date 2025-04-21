import Foundation
@testable import TrackForceChallenge

final class WeatherViewSpy: WeatherView {
    var didShowLoading = false
    var didCallShowForecast = false
    var didCallShowError = false
    
    private let callback: () -> Void
    
    init(callback: @escaping () -> Void = {}) {
        self.callback = callback
    }
    
    func showLoading(_ value: Bool) {
        didShowLoading = value
    }
    
    func showForecast(_ headerViewModel: ForecastHeaderViewModel) {
        didCallShowForecast = true
        callback()
    }
    
    func showError(_ title: String?, _ message: String) {
        didCallShowError = true
        callback()
    }
}

struct MockForecastInfo {
    static var sample: ForecastInfo {
        return ForecastInfo(
            city: CityInfo(name: "TestCity", coordinate: LocationCoordinate(latitude: 10, longitude: 10)),
            current: DayForecast(
                date: Date(),
                temperature: TemperatureRange(current: 25, min: 20, max: 30),
                weatherDescription: "Sunny",
                icon: "01d"
            ),
            daily: Array(repeating: DayForecast(
                date: Date(),
                temperature: TemperatureRange(current: 25, min: 20, max: 30),
                weatherDescription: "Cloudy",
                icon: "02d"
            ), count: 7)
        )
    }
}

final class MockLocationUseCase: GetUserLocationUseCaseProtocol {
    let result: Result<LocationCoordinate, LocationUserLocationError>
    init(result: Result<LocationCoordinate, LocationUserLocationError>) {
        self.result = result
    }
    
    func run(completion: @escaping (Result<LocationCoordinate, LocationUserLocationError>) -> Void) {
        completion(result)
    }
}

final class MockWeatherUseCase: GetWeatherUseCaseProtocol {
    let result: Result<ForecastInfo, WeatherUseCaseError>
    init(result: Result<ForecastInfo, WeatherUseCaseError>) {
        self.result = result
    }
    
    func run(for coordinate: LocationCoordinate, completion: @escaping (Result<ForecastInfo, WeatherUseCaseError>) -> Void) {
        completion(result)
    }
}

enum MockWeatherResponseFactory {
    static func make(days: Int) -> WeatherResponse {
        WeatherResponse(
            cod: "200",
            message: 0,
            cnt: days,
            list: (0..<days).map { i in
                ItemWeatherResponse(
                    dt: Int(Date().timeIntervalSince1970) + (i * 86400),
                    main: MainWeatherResponse(temp: 25, feelsLike: 24, tempMin: 20, tempMax: 30, pressure: 1012, seaLevel: 1012, grndLevel: 1012, humidity: 60, tempKf: 0),
                    weather: [WeatherInfoResponse(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
                    clouds: CloudWeatherResponse(all: 0),
                    wind: WindWeatherResponse(speed: 1.5, deg: 180, gust: 2.0),
                    visibility: 10000,
                    pop: 0,
                    sys: SysWeatherResponse(pod: "d"),
                    dtTxt: ""
                )
            },
            city: CityWeatherResponse(
                id: 123,
                name: "Test City",
                coord: CoordWeatherResponse(lat: 10, lon: 20),
                country: "TC",
                population: 100000,
                timezone: 0,
                sunrise: 1600000000,
                sunset: 1600030000
            )
        )
    }
}
