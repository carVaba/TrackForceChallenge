import Foundation

protocol WeatherBuilderProtocol {
    func build() -> WeatherViewController
}

// MARK: - Builder pattern
final class WeatherBuilder: WeatherBuilderProtocol {
    func build() -> WeatherViewController {
        let locationService = DefaultLocationService()
        let getUserLocationUseCase = GetUserLocationUseCase(locationService: locationService)
        
        // Use case
        let apiClient = WeatherAPIClient()
        let cache = SecureWeatherCache(fileManager: .default)
        let mapper = DefaultWeatherResponseMapper()
        let weatherService = DefaultWeatherAPIService(apiClient: apiClient,
                                                      mapper: mapper,
                                                      cache: cache)
        let getWeatherUseCase = GetWeatherUseCase(weatherService: weatherService)
        
        
        // View
        let viewController = WeatherViewController()
        
        // Presenter
        let presenter = WeatherPresenter(view: viewController,
                                         getWeatherListUseCase: getWeatherUseCase,
                                         getUserLocationUseCase: getUserLocationUseCase)
        
        viewController.presenter = presenter
        return viewController
    }
}
