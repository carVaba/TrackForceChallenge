import Foundation

protocol WeatherAPIClientProtocol {
    func fetchWeatherInfo(for coordinate: LocationCoordinate, completion: @escaping (Result<Data, Error>) -> Void)
}

final class WeatherAPIClient: WeatherAPIClientProtocol {
    private let days = Constants.MAX_DAYS
    
    func fetchWeatherInfo(for coordinate: LocationCoordinate, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = WeatherEndpoint.forecastURL(for: coordinate,
                                                    days: days,
                                                    apiKey: Constants.OPEN_WEATHER_KEY_API) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.emptyData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

