import Foundation
import OSLog

protocol WeatherAPIServiceProtocol {
    func getWeather(for coordinate: LocationCoordinate,
                    completion: @escaping (Result<ForecastInfo, Error>) -> Void)
}

final class DefaultWeatherAPIService: WeatherAPIServiceProtocol {
    private let apiClient: WeatherAPIClientProtocol
    private let cache: WeatherCacheProtocol?
    private let mapper: WeatherResponseMapperProtocol
    
    init(apiClient: WeatherAPIClientProtocol,
         mapper: WeatherResponseMapperProtocol,
         cache: WeatherCacheProtocol?) {
        self.apiClient = apiClient
        self.cache = cache
        self.mapper = mapper
    }
    
    private func save(info: ForecastInfo) {
        do {
            let data = try JSONEncoder().encode(info)
            try cache?.save(data)
        } catch {
            Logger.error(error.localizedDescription)
        }
    }
    
    private func load() -> ForecastInfo? {
        do {
            guard let data = try cache?.load() else { return nil }
            return try JSONDecoder().decode(ForecastInfo.self, from: data)
        } catch {
            Logger.error(error.localizedDescription)
            return nil
        }
    }

    func getWeather(for coordinate: LocationCoordinate,
                    completion: @escaping (Result<ForecastInfo, Error>) -> Void) {

        apiClient.fetchWeatherInfo(for: coordinate) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    let forecastInfo = mapper.map(from: response)
                    save(info: forecastInfo)
                    completion(.success(forecastInfo))
                } catch {
                    completion(.failure(error))
                }

            case .failure:
                if let cachedData = load() {
                    completion(.success(cachedData))
                } else {
                    completion(.failure(APIError.offlineNoCache))
                }
            }
        }
    }
}
