import Foundation

protocol WeatherResponseMapperProtocol {
    func map(from response: WeatherResponse) -> ForecastInfo
}

final class DefaultWeatherResponseMapper: WeatherResponseMapperProtocol {
    func map(from response: WeatherResponse) -> ForecastInfo {
        let city = CityInfo(
            name: response.city.name,
            coordinate: LocationCoordinate(
                latitude: response.city.coord.lat,
                longitude: response.city.coord.lon
            )
        )

        let forecasts: [DayForecast] = response.list.prefix(Constants.MAX_DAYS).compactMap { item in
            guard let weather = item.weather.first else { return nil }

            return DayForecast(
                date: Date(timeIntervalSince1970: TimeInterval(item.dt)),
                temperature: TemperatureRange(
                    current: item.main.temp,
                    min: item.main.tempMin,
                    max: item.main.tempMax
                ),
                weatherDescription: weather.main.capitalized,
                icon: weather.icon
            )
        }

        let current = forecasts.first ?? DayForecast(
            date: Date(),
            temperature: TemperatureRange(current: 0, min: 0, max: 0),
            weatherDescription: "Unavailable",
            icon: "questionmark"
        )

        return ForecastInfo(
            city: city,
            current: current,
            daily: forecasts
        )
    }
}
