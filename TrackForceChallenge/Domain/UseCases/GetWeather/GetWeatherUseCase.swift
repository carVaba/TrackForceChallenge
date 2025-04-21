enum WeatherUseCaseError: Error {
    case serviceFail
    
    var message: String {
        switch self {
            case .serviceFail:
            return "Service failed"
        }
    }
}

protocol GetWeatherUseCaseProtocol {
    func run(for coordinate: LocationCoordinate,
             completion: @escaping (Result<ForecastInfo, WeatherUseCaseError>) -> Void)
}

final class GetWeatherUseCase: GetWeatherUseCaseProtocol {
    private let weatherService: WeatherAPIServiceProtocol
    
    init(weatherService: WeatherAPIServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func run(for coordinate: LocationCoordinate, completion: @escaping (Result<ForecastInfo, WeatherUseCaseError>) -> Void) {
        weatherService.getWeather(for: coordinate) { result in
            switch result {
                case .success(let success):
                    completion(.success(success))
                case .failure:
                    completion(.failure(.serviceFail))
            }
        }
    }
}
